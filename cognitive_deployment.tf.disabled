resource "azurerm_cognitive_deployment" "gpt4o" {
  name                 = "gpt4o-mini"
  cognitive_account_id = azurerm_cognitive_account.this.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-07-18" # Beispiel: das Veröffentlichungsdatum des Modells
  }

  sku {
    name = "Standard"
  }
}