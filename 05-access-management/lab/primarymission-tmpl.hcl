# template policy gives access to secrets associated with groups user belongs to
path "secret/data/{{identity.entity.metadata.primarymission}}" {
  capabilities = ["read"]
}