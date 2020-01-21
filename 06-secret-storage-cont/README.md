# Secret Versioning
Make sure you are using version 2 of KV Secret Engine
```shell script
$ vault secrets list -detailed
```

Use the Web UI to create a new kv secret. then create new version of that secret

Retrieve specific version of the secret using CLI
```shell script
$ vault kv get -format=json -version=1 secret/db/prod | jq
```

Use the Web UI to create several new versions of the secret

Soft delete specific versions of the secret

Undelete versions

Permanent delete

Configure auto-delete
```shell script
$ vault kv metadata put -delete-version-after=10s secret/test
$ vault kv put secret/test message="data1"
$ vault kv put secret/test message="data2"
$ vault kv put secret/test message="data3"
```
# Cubbyhole Secrets Engine
[Cubbyhole documentation](https://www.vaultproject.io/docs/secrets/cubbyhole/)
Create single use token, then create cubbyhole secret
```shell script
$ vault token create -policy=default -use-limit=2 -ttl=2m -display-name="Limited use token" 
$ export VAULT_TOKEN=<token>
$ vault write cubbyhole/daily message="This will self destruct"
$ vault read cubbyhole/daily
$ vault read cubbyhole/daily
```

# Cubbyhole Response Wrapping
## Setup
```shell script
$ vault policy write gadgetuser gadgetuser.hcl
$ vault kv put secret/goldfinger/gadget type="super laser"
```

## Activity
```shell script
$ vault token create -policy=gadgetuser -wrap-ttl=20s -ttl=2h -use-limit=2
$ vault unwrap <wrapped token>
$ VAULT_TOKEN=<token> vault kv get secret/goldfinger/gadget
```

# AppRole
[AppRole API](https://www.vaultproject.io/api/auth/approle/index.html#create-new-approle) documentation
## Setup
```shell script
$ vault auth enable approle
$ vault policy write dailydigest dailydigest.hcl
$ vault write auth/approle/role/dailydigest-reader token_policies="dailydigest" \
          token_ttl=1h token_max_ttl=4h role_name="Q's Digest Reader App"
$ vault kv put secret/agentm/dailydigest message="Take the bloody shot"
```

## Activity
```shell script
$ vault read auth/approle/role/dailydigest-reader/role-id
$ vault write -f auth/approle/role/dailydigest-reader/secret-id
$ vault write auth/approle/login role_id="<role id>" secret_id="<secret id>"
$ VAULT_TOKEN=<token> vault kv get secret/agentm/dailydigest
$ VAULT_TOKEN=<token> vault token lookup
```

```shell script
$ vault write sys/wrapping/wrap secretid=<secret id>
$ vault unwrap <wrapped token>
```

