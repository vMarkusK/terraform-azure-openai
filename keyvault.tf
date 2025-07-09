resource "time_static" "current" {}

data "http" "icanhazip" {
  url = "http://ipv4.icanhazip.com"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
  lower   = true
}

resource "azurerm_user_assigned_identity" "this" {
  name                = local.uai_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_key_vault" "this" {
  name                = local.kv_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku_name                   = "standard"
  tenant_id                  = data.azuread_client_config.this.tenant_id
  enable_rbac_authorization  = true
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = ["${chomp(data.http.icanhazip.response_body)}/32"]
  }

}

resource "azurerm_role_assignment" "uai" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  principal_type       = "ServicePrincipal"
}

#trivy:ignore:AVD-AZU-0014
resource "azurerm_key_vault_key" "this" {
  name         = local.key_name
  key_vault_id = azurerm_key_vault.this.id


  key_type = "RSA"
  key_size = 4096
  key_opts = ["wrapKey", "unwrapKey"]

  expiration_date = timeadd(formatdate("YYYY-MM-DD'T'HH:mm:ss'Z'", time_static.current.rfc3339), "8760h")

  rotation_policy {
    automatic {
      time_before_expiry = "P60D"
    }

    expire_after         = "P365D"
    notify_before_expiry = "P30D"
  }

  lifecycle {
    ignore_changes = [expiration_date]
  }
}