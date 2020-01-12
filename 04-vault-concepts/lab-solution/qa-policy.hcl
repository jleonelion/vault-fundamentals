path "secret/data/qa*" {
  capabilities = ["read"]
}

path "secret/data/+/qa*" {
  capabilities = ["read"]
}
