# Agent-based-Single-Node-OpenShift
This Repository contains an ansible-role to install Single-Node-OpenShift with an Agend-Based-Installation approach.

## Requirements
- a management VM based on Linux (tested with Rocky Linux 9.4)
- ansible
- internet access from the management server
- access to the vcenter to upload the created iso

## Getting started
- Install your management System "sno-playground" from Template "manual-rocky94"
- Install ansible
- Create the agend-based.iso

## Clone the Github-Repo
```bash
# git clone
MYPATH=$PWD
mkdir -p $MYPATH/git && cd $MYPATH/git && git clone https://github.com/Patthecat249/sno-agent-based.git
```

## Create a ansible-vault with your vcenter-credentials
This file is needed to connect to your vcenter. Remember your password. You will paste it in a file in a few steps.
```bash
# Create a vcenter credentials file
ansible-vault create $MYPATH/git/sno-agent-based/agend-based-sno/vars/vcenter_credentials.yaml
vcenter_username: "<vcenter-username>"
vcenter_password: "<vcenter-password>"
```

## Create Red Hat pull-secret file
This file contains your Red Hat pull-secret. Please Download from and paste it into the file:
<https://console.redhat.com/openshift/downloads>
```bash
ansible-vault create $MYPATH/git/sno-agent-based/agend-based-sno/vars/pull-secret
# Paste your Red Hat pull-secret here
```

## Create a password-file for your ansible-vault password
This file contains your ansible-vault password to run the ansible-playbook without asking for vault-password
```bash
echo "Test1234" > $MYPATH/password.txt
```

## Run this playbook to create your install-config.yaml for your OpenShift-Installation
You can choose one of the parameters to prepare your install-config file.

### Install with Defaults from vars/main.yaml
```bash
# ansible-playbook 01-playbook.yaml --ask-vault-pass
cd $MYPATH/git/sno-agent-based/
ansible-playbook install-sno.yaml --vault-password-file $MYPATH/password.txt

```
### Customize Clustername and IP-Address
```bash
cd $MYPATH/git/sno-agent-based/
ansible-playbook install-sno.yaml --vault-password-file $MYPATH/password.txt -e "cluster_name=sno2" -e "ip_address=10.0.249.54"
```