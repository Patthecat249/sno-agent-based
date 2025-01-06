#!/bin/bash

# Variablen
DOWNLOAD_URL="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.16.24/openshift-install-linux-4.16.24.tar.gz"
ARTIFACTORY_URL="http://artifactory.home.local/artifactory/generic/pub/openshift-v4/x86_64/clients/ocp/4.16.24/openshift-install-linux-4.16.24.tar.gz"
ARTIFACTORY_USER="admin"  # Ersetzen mit deinem Benutzernamen
ARTIFACTORY_PASSWORD="Test1234!"  # Ersetzen mit deinem Passwort

# Lokaler Dateiname
FILE_NAME=$(basename "$DOWNLOAD_URL")

# Datei herunterladen
#echo "Lade Datei von $DOWNLOAD_URL herunter..."
#curl -O "$DOWNLOAD_URL"

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
