# policy that allows users to change there password
path "auth/userpass/users/{{identity.entity.aliases.<update here>.name}}" {
  capabilities = [ "update" ]
  allowed_parameters = {
    "password" = []
  }
}