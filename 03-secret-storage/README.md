# Environment Setup
## HashiCorp Vault
Locate binary download for your system from [vaultproject.io](https://www.vaultproject.io/)

Extract binary to folder on local system

Add binary location to PATH (if needed)

Verify install 
```
$ vault
```
*Bash, ZSH, Fish*: Setup command completion 
```
$ vault -autocomplete-install
$ exec $SHELL
```
## Optional utils
Install [jq utility](https://stedolan.github.io/jq/)
# Launch "Dev" Server
```shell script
$ vault server -dev
```

## Setup client environment
In new terminal, set environment variables
```shell script
$ export VAULT_ADDR='http://127.0.0.1:8200'
$ export VAULT_TOKEN='<copy Root Token from server output in other terminal>'
```

Perform simple status test using CLI
```shell script
$ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.3.0
Cluster Name    vault-cluster-0b30c99f
Cluster ID      c682e251-a75c-ac06-d96d-10516a35a03b
HA Enabled      false
```
Get host info using HTTP API
```shell script
$ curl -i -v \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    ${VAULT_ADDR}/v1/sys/host-info
```
Explore your dev server using web UI: http://127.0.0.1:8200

HashiCorp Documentation:
* [HTTP API Docs](https://www.vaultproject.io/api/overview.html)
* [CLI Docs](https://www.vaultproject.io/docs/commands/index.html)

# Key/Value CRUD Ops

**Create** `first` secret in Web UI (`message = hello`): http://127.0.0.1:8200

**Retrieve** `first` secret using CLI
```shell script
$ vault kv get secret/first
```
**Update** `first` secret using CLI
```shell script
$ vault kv put secret/first message="hello world" source="cli"
$ vault kv get secret/first
```
**Delete** `first` secret using HTTP API
```shell script
$ curl -i \
      --header "X-Vault-Token: ${VAULT_TOKEN}" \
      --request DELETE \
      ${VAULT_ADDR}/v1/secret/data/first
```
# Key/Value CRUD Ops with JSON

**Create**  new secret using key values in JSON file
```shell script
$ vault kv get secret/second
$ vault kv put secret/second @data.json
```
**Retrieve** secret using CLI and HTTP API
```shell script
$ vault kv get secret/second
$ vault kv get -format=json secret/second
$ curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    ${VAULT_ADDR}/v1/secret/data/second
```
 
**Update** secret to include self signed cert
```shell script
# create self signed certificate
$ openssl req -x509 -sha256 -nodes -newkey rsa:2048 -keyout selfsigned.key -out cert.pem
# update payload.json file with contents of pem file
...
$ vault kv put secret/second @payload.json
```

# Additional Resources
- [CLI Reference](https://www.vaultproject.io/docs/commands/index.html)
- [HTTP API](https://www.vaultproject.io/api/overview.html)
- [Linux File Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)