# Agent-based-Single-Node-OpenShift
This Repository contains an ansible-role to install Single-Node-OpenShift with an Agend-Based-Installation approach.

## Architecture
![Architekture of SNO-Workaround](images/sno-architecture.drawio2.svg)

## How it works!
![Architekture of SNO-Workaround](images/sno-architecture.drawio3.svg)


## Requirements
- a management VM based on Linux (tested with Rocky Linux 9.4)
- ansible
- internet access from the management server
- access to the vcenter to upload the created iso
- mac-address 

## Getting started
- Install your management System "sno-playground" from Template "manual-rocky94"
- Install ansible
- Create the agend-based.iso

## Clone the Github-Repo
```bash
# Installation git and podman
dnf install -y git podman


# git clone
```bash
MYPATH=$PWD
mkdir -p $MYPATH/git && cd $MYPATH/git && git clone https://github.com/Patthecat249/sno-agent-based.git && cd $MYPATH/git/sno-agent-based && git switch complete-air-gap
```

# How to build the Container
```bash
# Containerfile muss vorher gebaut werden!
```


## Build the sno-airgap-installer-Container with the Containerfile
You can build the sno-airgap-installer-Container for different OpenShift-Versions.

```bash
# Run the podman build command
# Container for OpenShift 4.12.40
OPENSHIFT_VERSION=4.12.40
podman build -t patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION} -f containerfile/Containerfile --build-arg OPENSHIFT_VERSION=${OPENSHIFT_VERSION}
podman login patrick.artifactory.home.local -u admin -p 'Test1234!'
podman push patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION}

# Container for OpenShift 4.13.41
OPENSHIFT_VERSION=4.13.41
podman build -t patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION} -f containerfile/Containerfile --build-arg OPENSHIFT_VERSION=${OPENSHIFT_VERSION}
podman login patrick.artifactory.home.local -u admin -p 'Test1234!'
podman push patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION}

# Container for OpenShift 4.14.25
OPENSHIFT_VERSION=4.14.25
podman build -t patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION} -f containerfile/Containerfile --build-arg OPENSHIFT_VERSION=${OPENSHIFT_VERSION}
podman login patrick.artifactory.home.local -u admin -p 'Test1234!'
podman push patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION}


# Container for OpenShift 4.16.24
OPENSHIFT_VERSION=4.16.24
podman build -t patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION} -f containerfile/Containerfile --build-arg OPENSHIFT_VERSION=${OPENSHIFT_VERSION}
podman login patrick.artifactory.home.local -u admin -p 'Test1234!'
podman push patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION}

```

## Run the Container
Before you run the container, make sure, that you have a folder where the installationfiles are placed on your bastion-Host
I recommend: /opt/sno/sno-installations/

```bash
# The installationfiles will be stored under /opt/sno/sno-installations/
# Here are the files store for each installation
# You must create this folder on your Bastion host and place there some files
# - pull-secret
# - vcenter-credentials.yaml
# - root-ca.crt
# - password.txt

mkdir -p /opt/sno/sno-installations/


OPENSHIFT_VERSION=4.16.19
podman run --rm --hostname sno-airgap-installer -it -v /opt/sno/sno-installations/:/opt/sno/sno-installations/ --name sno-airgap-installer patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION} /bin/bash

# Falls SELinux aktiv ist, bitte folgenden Befehl verwenden
OPENSHIFT_VERSION=4.16.19
podman run --rm --hostname sno-airgap-installer -it -v /opt/sno/sno-installations/:/opt/sno/sno-installations/:Z --name sno-airgap-installer patrick.artifactory.home.local/sno/sno-airgap-installer:${OPENSHIFT_VERSION} /bin/bash

podman run --rm --hostname sno-airgap-installer -it -v /opt/sno/sno-installations/:/opt/sno/sno-installations/:Z --name sno-airgap-installer-standalone patrick.artifactory.home.local/sno/sno-airgap-installer-standalone:${OPENSHIFT_VERSION} /bin/bash
```

## Create a ansible-vault with your vcenter-credentials
This file is needed to connect to your vcenter. Remember your password. You will paste it in a file in a few steps.
```bash

# Create a vcenter credentials file
ansible-vault create /opt/sno/sno-installations/credentials/vcenter_credentials.yaml
vcenter_username: "<vcenter-username>"
vcenter_password: "<vcenter-password>"
container_registry_username: "<container_registry_username>"
container_registry_password: "<container_registry_password>"
```

## Create Red Hat pull-secret file
This file contains your Red Hat pull-secret. Please Download from and paste it into the file:
<https://console.redhat.com/openshift/downloads>
```bash
ansible-vault create /opt/sno/sno-installations/credentials/pull-secret
# Paste your Red Hat pull-secret here
```

## Create a password-file for your ansible-vault password
This file contains your ansible-vault password to run the ansible-playbook without asking for vault-password
```bash
echo "Test1234" > /opt/sno/sno-installations/password.txt
```

## Run this playbook to create your install-config.yaml for your OpenShift-Installation
You can choose one of the parameters to prepare your install-config file.

### Install with Defaults from vars/main.yaml
```bash
# ansible-playbook 01-playbook.yaml --ask-vault-pass
cd 
ansible-playbook /opt/sno/git/install-sno.yaml --vault-password-file /opt/sno/sno-installations/password.txt

```
### Customize Clustername and IP-Address and MAC-Address
```bash
ansible-playbook /opt/sno/git/install-sno.yaml --vault-password-file /opt/sno/sno-installations/password.txt -e "cluster_name=sno3" -e "ip_address=10.0.249.55" -e "mac_address=00:50:56:9c:49:8b"

### Im Container ausführen
# SNO1
ansible-playbook -i localhost, -c local /opt/sno/git/install-sno.yaml --vault-password-file /opt/sno/sno-installations/password.txt -e "cluster_name=sno1" -e "ip_address=172.16.11.11" -e "network_name=openshift-12" -e "dns_server=172.16.11.10" -e "dir_base=/opt/sno/sno-installations/"

# Online-Variante SNO2
ansible-playbook -i localhost, -c local /opt/sno/git/install-sno.yaml --vault-password-file /opt/sno/
sno-installations/credentials/password.txt -e "cluster_name=sno2" -e "ip_address=10.0.249.54" -e "network_name=pg-home" -e "dns_server=10.0.249.53" -e "dir_base=/opt/sno/sno-installations/" -e "ip_address_and_subnet=10.0.249.54/24" -e "cidr_and_subnet=10.0.249.0/24" -e "gateway=10.0.249.1"

# SNO2
ansible-playbook -i localhost, -c local /opt/sno/git/install-sno.yaml --vault-password-file /opt/sno/sno-installations/password.txt -e "cluster_name=sno2" -e "ip_address=172.16.11.12" -e "mac_address=00:50:56:9c:49:8b" -e "network_name=openshift-12" -e "dns_server=172.16.11.10" -e "openshift_version=4.14.25"

# SNO3
ansible-playbook -i localhost, -c local /opt/sno/git/install-sno.yaml --vault-password-file /opt/sno/sno-installations/password.txt -e "cluster_name=sno3" -e "ip_address=172.16.11.13" -e "mac_address=00:50:56:9c:49:8c" -e "network_name=openshift-12" -e "dns_server=172.16.11.10" -e "openshift_version=4.15.13"

# SNO4
ansible-playbook -i localhost, -c local /opt/sno/git/install-sno.yaml --vault-password-file /opt/sno/sno-installations/password.txt -e "cluster_name=sno4" -e "ip_address=172.16.11.14" -e "mac_address=00:50:56:9c:49:8d" -e "network_name=openshift-12" -e "dns_server=172.16.11.10" -e "openshift_version=4.16.19"
```

### Überprüfen des Installationsstatus der SNO-Cluster
```bash
# SNO1
openshift-install agent wait-for bootstrap-complete --dir=/opt/sno/sno-clusters/sno1
openshift-install agent wait-for install-complete --dir=/opt/sno/sno-clusters/sno1
export KUBECONFIG=/opt/sno/sno-clusters/sno1/auth/kubeconfig
oc whoami --show-console

# SNO2
openshift-install agent wait-for bootstrap-complete --dir=/opt/sno/sno-clusters/sno2
openshift-install agent wait-for install-complete --dir=/opt/sno/sno-clusters/sno2

# SNO3
openshift-install agent wait-for bootstrap-complete --dir=/opt/sno/sno-clusters/sno3
openshift-install agent wait-for install-complete --dir=/opt/sno/sno-clusters/sno3

# SNO4
openshift-install agent wait-for bootstrap-complete --dir=/opt/sno/sno-clusters/sno4
openshift-install agent wait-for install-complete --dir=/opt/sno/sno-clusters/sno4

```

# Optional Section
## How to mirror necessary tools like oc, openshift-install, kubectl, etc.

```bash
#!/bin/bash

# Variablen
DOWNLOAD_URL="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.16.24/openshift-install-linux-4.16.24.tar.gz"
ARTIFACTORY_URL="http://artifactory.home.local/artifactory/generic/pub/openshift-v4/x86_64/clients/ocp/4.16.24/openshift-install-linux-4.16.24.tar.gz"
ARTIFACTORY_USER="admin"  # Ersetzen mit deinem Benutzernamen
ARTIFACTORY_PASSWORD="Test1234!"  # Ersetzen mit deinem Passwort

# Lokaler Dateiname
FILE_NAME=$(basename "$DOWNLOAD_URL")

# Datei herunterladen
echo "Lade Datei von $DOWNLOAD_URL herunter..."
curl -O "$DOWNLOAD_URL"

# Prüfen, ob der Download erfolgreich war
if [ $? -ne 0 ]; then
  echo "Fehler beim Herunterladen der Datei."
  exit 1
fi

echo "Datei $FILE_NAME erfolgreich heruntergeladen."

# Datei zu Artifactory hochladen
echo "Lade Datei zu Artifactory hoch..."
curl -u "$ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD" \
     -T "$FILE_NAME" \
     "$ARTIFACTORY_URL"

# Prüfen, ob der Upload erfolgreich war
if [ $? -ne 0 ]; then
  echo "Fehler beim Hochladen der Datei zu Artifactory."
  exit 1
fi

echo "Datei $FILE_NAME erfolgreich zu Artifactory hochgeladen."

```