#!/bin/bash

# Variablen
## openshift-install Client
# OCPVERSION=4.12.40
# OCPVERSION=4.13.41
# OCPVERSION=4.14.25
OCPVERSION=4.15.13
DOWNLOAD_URL_OPENSHIFT_INSTALL="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OCPVERSION}/openshift-install-linux-${OCPVERSION}.tar.gz"
ARTIFACTORY_URL_OPENSHIFT_INSTALL="https://artifactory.home.local/artifactory/generic/pub/openshift-v4/x86_64/clients/ocp/${OCPVERSION}/openshift-install-linux-${OCPVERSION}.tar.gz"

## oc Client
DOWNLOAD_URL_OC="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OCPVERSION}/openshift-client-linux-${OCPVERSION}.tar.gz"
ARTIFACTORY_URL_OC="https://artifactory.home.local/artifactory/generic/pub/openshift-v4/x86_64/clients/ocp/${OCPVERSION}/openshift-client-linux-${OCPVERSION}.tar.gz"

ARTIFACTORY_USER="admin"  # Ersetzen mit deinem Benutzernamen
ARTIFACTORY_PASSWORD="Test1234!"  # Ersetzen mit deinem Passwort

# Lokaler Dateiname
FILE_NAME_OC=$(basename "$DOWNLOAD_URL_OC")
FILE_NAME_OPENSHIFT_INSTALL=$(basename "$DOWNLOAD_URL_OPENSHIFT_INSTALL")

# Datei herunterladen
echo "Lade Datei von $DOWNLOAD_URL_OC herunter..."
curl -O "$DOWNLOAD_URL_OC"

# Prüfen, ob der Download erfolgreich war
if [ $? -ne 0 ]; then
  echo "Fehler beim Herunterladen der Datei."
  exit 1
fi

echo "Datei $FILE_NAME_OC erfolgreich heruntergeladen."

echo "Lade Datei von $DOWNLOAD_URL_OPENSHIFT_INSTALL herunter..."
curl -O "$DOWNLOAD_URL_OPENSHIFT_INSTALL"

# Prüfen, ob der Download erfolgreich war
if [ $? -ne 0 ]; then
  echo "Fehler beim Herunterladen der Datei."
  exit 1
fi

echo "Datei $FILE_NAME_OPENSHIFT_INSTALL erfolgreich heruntergeladen."

# Datei zu Artifactory hochladen
echo "Lade oc client zu Artifactory hoch..."
curl -u "$ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD" \
     -T "$FILE_NAME_OC" \
     "$ARTIFACTORY_URL_OC"

echo "Lade openshift-install client zu Artifactory hoch..."
curl -u "$ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD" \
     -T "$FILE_NAME_OPENSHIFT_INSTALL" \
     "$ARTIFACTORY_URL_OPENSHIFT_INSTALL"

# Prüfen, ob der Upload erfolgreich war
if [ $? -ne 0 ]; then
  echo "Fehler beim Hochladen der Datei zu Artifactory."
  exit 1
fi

echo "Datei $FILE_NAME_OC erfolgreich zu Artifactory hochgeladen."