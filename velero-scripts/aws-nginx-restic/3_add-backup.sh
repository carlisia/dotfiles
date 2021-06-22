#!/bin/bash

. ../demo-magic.sh

random=$(openssl rand -hex 12)
pe "velero backup create $random --include-namespaces restic-nginx"

# pe "velero backup logs $random | grep error"
pe "velero backup logs $random"

pe "velero backup describe $random --details"

pe "kubectl get podvolumebackups -l velero.io/backup-name=$random -o yaml"