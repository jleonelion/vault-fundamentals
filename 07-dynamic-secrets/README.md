# Dynamic Secrets

```shell script
$ vault secrets enable -path=aws aws
$ vault write aws/config/root \
    access_key=<access_key> \
    secret_key=<secret_key>
$ vault write aws/roles/my-role \
    credential_type=iam_user \
    policy_document=@aws-policy.json
$ vault read aws/creds/my-role
$ vault lease revoke aws/creds/my-role/<id>
```
