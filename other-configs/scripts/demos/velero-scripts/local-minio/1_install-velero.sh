#!/bin/bash

. ../demo-magic.sh

clear

# p "Start the server and the local storage service (Minio)"
# pe "kubectl apply -f ~/work/src/github.com/heptio/velero/examples/minio/00-minio-deployment.yaml"

# p "#Command to install Velero in a cluster:"
# p " "
# p 'velero install \ ' 
# p '        --provider aws \ '
# p '        --bucket acme-development \ ' 
# p '        --use-volume-snapshots=false \ '
# p '        --secret-file ~/creds/credentials-velero-minio \ '
# p '        --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://127.0.0.1:9000 \ '
# p '# --- '
# wait

pe "velero install --provider aws --bucket acme-development --use-volume-snapshots=false --secret-file ~/creds/credentials-velero-minio --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://10.0.0.14:9000 --image=carlisia/velero:a0a59ed29bc25720aac61ea0"
# wait

# pe "kubectl logs deployment/velero -n velero"
# p "#end of log"
# wait


# p "#Velero installed in a pod as a deployment:"
# cat images/pod.txt
# pe ./delete-all-backups.sh -n
