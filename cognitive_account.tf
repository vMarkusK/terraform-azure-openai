resource "azurerm_cognitive_account" "this" {
  name                = local.oai_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  kind                = "OpenAI"
  sku_name            = "S0"

  local_auth_enabled                 = false
  outbound_network_access_restricted = false
  public_network_access_enabled      = false
  custom_subdomain_name              = random_string.suffix.result

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.this.id
    ]
  }

  customer_managed_key {
    key_vault_key_id   = azurerm_key_vault_key.this.id
    identity_client_id = azurerm_user_assigned_identity.this.client_id
  }

  depends_on = [azurerm_key_vault.this, azurerm_role_assignment.crypo_user, azurerm_role_assignment.crypo_service]
}