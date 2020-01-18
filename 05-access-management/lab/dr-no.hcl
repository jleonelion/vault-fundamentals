# policy that gives us right to read the secrets associated with "dr no" mission
path "secret/data/dr-no" {
  capabilities = ["read"]
}
