# How to build the Container
```bash
# Change the git-root-folder of the Github Repositoriy
podman build -t snohelper-rockylinux:9.3 -f containerfile/Containerfile
```

# Run the container
```bash
# Change the git-root-folder of the Github Repositoriy
podman run --rm -it -v .:/workspace --name snohelper localhost/snohelper-rockylinux:9.3 /bin/bash

# Load container.registries.conf and pull-secret
# The installationfiles will be stored under /opa/sva
mkdir /opt/sva
podman run --rm -it -v .:/workspace -v /opt/sva:/opt/sva --name snohelper localhost/snohelper-rockylinux:9.3 /bin/bash
```
