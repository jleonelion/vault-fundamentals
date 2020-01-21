# Lab Solution
**Don't look at this unless you are really stuck!**

## Step 1
1. Write the various policy file: [intel-upload Policy](intel-upload.hcl)
1. Create policy in Vault `vault policy write intel lab/intel-upload.hcl`
1. Create various keys in vault using `vault kv put`
1. Enable userpass auth method `vault auth enable userpass`
1. Create james.bond account and assign to policy: `vault write auth/userpass/users/james.bond password=shaken policies=intel`
1. Log in as that user: `vault login -method=userpass username=james.bond password=shaken`