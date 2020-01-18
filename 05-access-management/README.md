# Policies
```shell script
$ vault policy list
$ vault policy -h
$ vault policy read default
```
[Vault Policy Documentation](https://www.vaultproject.io/docs/concepts/policies.html)
(note kv2 paths are secret/data/foo not secret/foo)
## Independent Lab Activity
Using the CLI:
1. Create a `intel-upload` policy that provides `create` and `update` access to any secret named "agentintel" in the 2nd segment
1. Create secrets at the following paths (use whatever key values you want): `secrete/data/dr-no`, `secret/data/dr-no/agentintel`, `secret/data/goldeney/agentintel`, `secret/data/agentintel`
1. Enable the `userpass` auth method and create `james.bond` user associated with the `intel-upload` policy
1. Authenticate with Vault as the `james.bond` user and execute the below commands to test for correctness
```shell script
# these commands should be denied/fail
$ vault kv get secret/dr-no
$ vault kv get secret/dr-no/agentintel
$ vault kv get secret/goldeneye
$ vault kv get secret/agentintel
$ vault kv put secret/dr-no newkey=newvalue
$ vault kv put secret/agentintel newkey=newvalue

# these commands should all pass
$ vault kv put secret/dr-no/agentintel newkey=newvalue
$ vault kv put secret/goldeneye/agentintel newkey=newvalue
$ vault kv put secret/spectre/agentintel newkey=newvalue
```
# Identities, Aliases, and Groups Lecture
[Identity Secrets Engine](https://www.vaultproject.io/docs/secrets/identity/)

# Identities, Aliases, and Groups Lab
## Setup
```shell script
# create policies
$ vault policy write dr-no lab/dr-no.hcl
$ vault policy write goldeye lab/goldeye.hcl
$ vault policy write intel-upload lab/intel-upload.hcl
$ vault policy write gadgetuser lab/gadgetuser.hcl

# setup userpass auth method and create seperate accounts for Mr. Bond
$ vault auth enable userpass
$ vault write auth/userpass/users/james.bond password="shaken" policies="dr-no"
$ vault write auth/userpass/users/jbond007 password="notstirred" policies="goldeye"
```
## Activity

1. Create "James Bond" identity (associate with gadgetuser policy) and aliases using Web UI
1. Create internal group for "Secret Agents" (associate with intel-upload) using Web UI with James Bond entity as a member
1. Authenticate as james.bond and examine capabilities
```shell script
$ vault login -method=userpass username=james.bond password=shaken
$ vault token capabilities secret/data/dr-no
$ vault token capabilities secret/data/dr-no/agentintel
$ vault token capabilities secret/data/goldeye
$ vault token capabilities secret/data/goldeye/agentintel
```
# Policy Template
Templated policy [parameters](https://www.vaultproject.io/docs/concepts/policies.html#templated-policies)
## Setup
```shell script
$ vault auth enable userpass
$ vault auth list
```
1. Update [passreset-tmpl.hcl](lab/passreset-tmpl.hcl) based on accessor
1. Review [primarymission-tmpl.hcl](lab/primarymission-tmpl.hcl)
1. Create policies and user
```shell script
$ vault policy write primarymission lab/primarymission-tmpl.hcl
$ vault policy write passreset lab/passreset-tmpl.hcl
$ vault write auth/userpass/users/james.bond password="shaken"
$ vault kv put secret/goldeneye key=value
```

## Activity
1. Create "James Bond" identity nd aliases using Web UI
1. Create internal group for "Secret Agents" (associate with `primarymission` and `passreset` policies) using Web UI with James Bond entity as a member
1. Authenticate as `james.bond` and examine capabilities
```shell script
$ vault token capabilities secret/data/dr-no
$ vault token capabilities secret/data/dr-no/agentintel
$ vault token capabilities secret/data/goldeye
$ vault kv put secret/dr-no newkey=newvalue
$ vault write auth/userpass/users/james.bond password="stirred"
```

# Tokens

