resource "azurerm_cognitive_deployment" "o4_mini" {
  name                 = "o4-mini"
  cognitive_account_id = azurerm_cognitive_account.this.id

  model {
    format  = "OpenAI"
    name    = "o4-mini"
    version = "2025-04-16"
  }

  sku {
    name = "GlobalStandard"
  }
}