# AWS Secrets Engine Lab
[Official documentation of the AWS secrets engine](https://www.vaultproject.io/docs/secrets/aws/index.html)

## Setup
You need an AWS account for this lab.  If you don't have one, [create a free tier account](https://aws.amazon.com/free/)

Create AWS user `vault` attaching the Managed Policy "IAMFullAccess"
Copy access keys of `vault` user

## Activity
```shell script
# enable aws secrets engine
$ vault secrets enable -path=aws aws

# provide Vault with AWS keys
$ vault write aws/config/root \
 access_key=<access_key> \
 secret_key=<secret_key> \
 region=us-west-1


# create AWS role that will be assigned to identities Vault generates
$ vault write aws/roles/ec2-admin \
    credential_type=iam_user \
    policy_document=@ec2-policy.json

# read secret (this will have Vault create an AWS user ) 
$ vault read aws/creds/ec2-admin

# revoke the generated secret (this will have Vault delete the AWS user)
$ vault lease revoke aws/creds/ec2-admin/<id>
```
# Database Secrets Engine Lab

## Setup
Create EC2 instance on AWS:
* AMI: ami-0dd655843c87b6930 (Ubuntu 18.04)
* Configure Security Group: restrict SSH to "My IP" & open port 27017 

Create new key pair: `MongoDB`
Connect to server using local SSH client: `ssh -i "MongoDB.pem" ubuntu@ec2-<nnnn>.us-west-1.compute.amazonaws.com`
Install MongoDB on server
```shell script
# use apt packages to install
$ sudo apt update
$ sudo apt install -y mongodb
# verify mongo is running
$ sudo systemctl status mongodb
```
Setup admin account in Mongo using Mongo shell
```shell script
use admin
db.createUser(
  {
    user: "admin",
    pwd: "P@55w0rd",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
```
Update `/etc/mongodb.conf` by setting `auth=true` and appending **internal ip** to `bind_ip = 127.0.0.1,`
Restart MongoDB process and login using admin account
```shell script
$ sudo systemctl restart mongodb
$ mongo -u admin -p --authenticationDatabase admin --host <internal ip address>
```
Verify only 1 account exists (via Mongo shell)
```shell script
$ mongo -u admin -p --authenticationDatabase admin
> use admin
> show users
```

## Activty
With the Vault "dev" server running locally, setup db secrets engine to talk to MongoDB servers running on AWS
```shell script
$ vault secrets enable database
$ vault write database/config/aws-mongodb \
      plugin_name=mongodb-database-plugin \
      allowed_roles="007" \
      connection_url="mongodb://{{username}}:{{password}}@<public-ip>:27017" \
      username="admin" \
      password="P@55w0rd"

$ vault write database/roles/007 \
      db_name=aws-mongodb \
      creation_statements='{ "db": "admin", "roles": [{ "role": "readWrite" }, {"role": "read", "db": "mi6"}] }' \
      default_ttl="1h" \
      max_ttl="24h"
```
Use vault to generate a MongoDB user/pass credential
```shell script
$ vault read database/creds/007
```
Toggle back to AWS server and run `show users` again

Revoke the Vault lease
```shell script
$ vault lease revoke <vault lease id>
``` 
Return to AWS server and run `show users` (on last time)