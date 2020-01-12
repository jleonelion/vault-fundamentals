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

# Cubbyhole Response Wrapping



