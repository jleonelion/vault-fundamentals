# Lab Solution
Don't look at this unless you are really stuck!
## Step 1
```shell script
$ vault policy write qa ./qa-policy.hcl 
```
## Step 2
```shell script
$ vault kv put secret/qa1 key=qa1
$ vault kv put secret/qa2 key=qa2
$ vault kv put secret/stub-accounts/qa key=stub-accounts
```
## Step 3
```shell script
$ vault auth enable userpass
$ vault write auth/userpass/users/qa \
    password=strongpassword \
    policies=qa
```
## Step 4
```shell script
$ vault login -method=userpass \
    username=qa \
    password=strongpassword
```
