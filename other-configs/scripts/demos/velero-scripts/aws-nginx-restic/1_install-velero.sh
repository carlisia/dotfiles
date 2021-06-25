#!/bin/bash

. ../demo-magic.sh

clear

p "#setup variables:"
pe "BUCKET=c-aws-velero-bucket"
pe "REGION=us-east-2"
p "#install Velero:"
pe "velero install --provider aws --bucket $BUCKET --backup-location-config region=$REGION --snapshot-location-config region=$REGION --secret-file ~/creds/credentials-velero --use-restic"
wait

pe "kubectl logs deployment/velero -n velero"
p "#end of log"
wait

# p "#Velero installed in a pod as a deployment:"
# cat images/pod.txt

# pe ./delete-all-backups.sh -n


velero install --provider aws --bucket c-aws-velero-bucket --backup-location-config region=us-east-2 --snapshot-location-config region=us-east-2 --secret-file ~/creds/credentials-velero