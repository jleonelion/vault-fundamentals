# Policies
```shell script
$ vault policy list
$ vault policy -h
$ vault policy read default
```
[Vault Policy Documentation](https://www.vaultproject.io/docs/concepts/policies.html)
(not kv2 paths are secret/data/foo not secret/foo)
## Lab activity
Using the CLI:
1. Create a `qa` policy that provides read-only access to any secret with "qa" in the 2nd or 3rd path segment
1. Create secrets at the following paths: `secret/qa1`, `secret/qa2`, `secret/stub-accounts/qa`, `secret/stub-accounts/prod`
1. Enable the `userpass` auth method and create `qa` user associated with that policy
1. Authenticate with Vault using the qa user and execute the below commands to test for correctness
```shell script
$ vault kv get secret/qa1
# should print your secret information
$ vault kv get secret/qa2
# should print your secret information
$ vault kv get secret/stub-account/qa
# should print your secret information

# run negative tests
$ vault kv get secret/stub-accounts/prod
Error reading secret/data/stub-accounts/prod: Error making API request.

URL: GET http://127.0.0.1:8200/v1/secret/data/stub-accounts/prod
Code: 403. Errors:

* 1 error occurred:
	* permission denied

$ vault kv put secret/qa2 key=value
Error writing data to secret/data/qa2: Error making API request.

URL: PUT http://127.0.0.1:8200/v1/secret/data/qa2
Code: 403. Errors:

* 1 error occurred:
	* permission denied

$ vault kv get secret/stub-accounts/prod
Error reading secret/data/stub-accounts/prod: Error making API request.

URL: GET http://127.0.0.1:8200/v1/secret/data/stub-accounts/prod
Code: 403. Errors:

* 1 error occurred:
	* permission denied
```

# Identity Entities and Groups
Setup
```shell script
# create policies
$ vault policy write dr-no dr-no.hcl
$ vault policy write goldeye goldeye.hcl
$ vault policy write intel-upload intel-upload.hcl
# setup userpass auth method and create seperate accounts for James
$ vault auth enable userpass
$ vault write auth/userpass/users/james.bond password="shaken" policies="dr-no"
$ vault write auth/userpass/users/jbond007 password="notstirred" policies="goldeye"
```
Create identity and aliases
```shell script
# create the entity that will consolidate James' aliases
$ vault write identity/entity name="james-bond" policies="intel-upload" \
        metadata=organization="MI6" \
        metadata=agentId="007"
# before creating alias, we need to know mount access of userpass
$ vault auth list
# create alias for james.bond
$ vault write identity/entity-alias name="james-bond" \
          canonical_id=<entity_id> \
          mount_accessor=<userpass_accessor>
# create alias for jbond007
$ vault write identity/entity-alias name="james-bond" \
          canonical_id=<entity_id> \
          mount_accessor=<userpass_accessor>
# review entity details
$ vault read identity/entity/id/<entity_id>
```
Authenticate and examine capabilities
```shell script
$ $ vault login -method=userpass username=james.bond password=shaken
$ vault token capabilities secret/data/dr-no
$ vault token capabilities secret/data/goldeye
```
Create internal group for secret agents


# Policy Templates

# Tokens

# AppRole

# Secure Introduction