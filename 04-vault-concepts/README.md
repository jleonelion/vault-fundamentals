# Architecture
Examine dev server setup
```shell script
$ vault secrets
$ vault policy
$ vault auth
$ vault audit
```

# Sealing and Unsealing
Start server in "non-dev" mode using included simple_config.hcl as config file
```shell script
$ vault server -config simple_config.hcl
```
In seperate terminal
```shell script
$ vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            n/a
HA Enabled         false

$ vault operator init
Unseal Key 1: 7DIm0bgi5JzZzDN15W8yKH0cnNsv22MXHVr0QmWYvqpx
Unseal Key 2: t5c16ptSYfAb+9izR2vVqjG6ZH5A/TRSvUrEMoEMdmVH
Unseal Key 3: E+yxFIu6S+IbJaRJD0lufyg7HPMoc9xAppPlNqm9oxnI
Unseal Key 4: fR5r6eiMMb6t2VQ4L7IjVu03c+TPq60psaRKW+DuTd4b
Unseal Key 5: hNTf2l0igDlr8cFtJxGTeAVwUa3GtFfGzi/97hXCCcO/

Initial Root Token: s.bWXBd2eDWmDGvVsgXgdmHjfY

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.

$ vault operator unseal
Unseal Key (will be hidden): 
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       6a429854-26df-e259-2db5-24265e7793cb
Version            1.3.0
HA Enabled         false

$ vault operator unseal
Unseal Key (will be hidden): 
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       6a429854-26df-e259-2db5-24265e7793cb
Version            1.3.0
HA Enabled         false

$ vault operator unseal
Unseal Key (will be hidden): 
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.3.0
Cluster Name    vault-cluster-655462ea
Cluster ID      f6aefbfe-dbd1-d4af-2c14-ca098145df7c
HA Enabled      false

$ vault status
```
View [seal Stanza](https://www.vaultproject.io/docs/configuration/seal/index.html) to configure auto-unseal

# Server Configuration File
[Vault Configuration](https://www.vaultproject.io/docs/configuration/index.html) docs

# Default Plugins

```shell script
$ vault plugin
```
* [Secret Engines](https://www.vaultproject.io/docs/secrets/index.html)
Enable the engine
```shell script
$ vault secrets enable kv
$ vault secrets list
$ vault path-help kv
$ vault secrets enable -path=secret kv
$ vault secrets enable -path=secret/007 kv
$ vault secrets enable -path=007/skyfall kv
$ vault secrets enable -path=007/spectre -description="secrets for mission SPECTRE" kv
```
Move the path that the secret is mounted too
```shell script
$ vault secrets move 007/skyfall 007/goldeneye
```
Disable the engine (all secrets are revoke if the engine support revocation)
```shell script
$ vault secrets disable 007/goldeneye
```
* [Auth Methods](https://www.vaultproject.io/docs/auth/index.html)
```shell script
$ vault auth enable userpass
$ vault write auth/userpass/users/jbond007 \
    password=shaken \
    policies=default
$ vault login -method=userpass \
    username=jbond007 \
    password=shaken
```
* [Audit Backends](https://www.vaultproject.io/docs/audit/index.html)
```shell script
$ vault audit enable file file_path=vault_audit.log
$ vault kv put 007/spectre/location city="Mexico City"" 
$ cat vault_audit.log
```

