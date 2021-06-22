#!/bin/bash

. ../demo-magic.sh

pe "kubectl apply -f /Users/carlisia/work/src/github.com/vmware-tanzu/velero/examples/nginx-app/with-pv.yaml"

pe "kubectl get pods --namespace restic-nginx"
p "#kubectl -n restic-nginx annotate pod/<deployment_name> backup.velero.io/backup-volumes=nginx-logs"

cmd

random=$(openssl rand -hex 12)
pe "velero backup create $random --include-namespaces restic-nginx"

cmd



----
velero backup create nginx-backup --include-namespaces nginx-example