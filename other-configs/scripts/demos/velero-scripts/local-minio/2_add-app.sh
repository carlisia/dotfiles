#!/bin/bash

. ../demo-magic.sh

pe "kubectl apply -f base.yaml"

pe "kubectl get ns"

# pe "kubectl get pods --namespace nginx-example"
# wait 

# pe "kubectl -n nginx-example annotate pod/$(kubectl -n nginx-example get pod -o name|cut -d/ -f2) backup.velero.io/backup-volumes=nginx-logs"
