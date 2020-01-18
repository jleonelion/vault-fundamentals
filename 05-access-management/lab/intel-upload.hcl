#  policy that gives us right to upload to any agent intel subfolder
path "secret/data/+/agentintel" {
  capabilities = ["create", "update"]
}