# policy gives us right to read secrets related to goldeneye mission
path "secret/data/goldeye" {
  capabilities = ["read"]
}
