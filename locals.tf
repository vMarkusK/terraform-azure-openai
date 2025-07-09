# Naming
locals {
  rg_name  = format("rg-%s-%s-%s", var.env, var.usecase, var.suffix)
  uai_name = "uai-${var.usecase}-${random_string.suffix.result}"
  kv_name  = "kv-${var.usecase}-${random_string.suffix.result}"
  key_name = "cmk-${var.usecase}-${random_string.suffix.result}"
  oai_name = "oai-${var.usecase}-${random_string.suffix.result}"
}