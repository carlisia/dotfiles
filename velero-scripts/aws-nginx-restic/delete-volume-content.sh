#!/bin/bash

. ../demo-magic.sh

pe "kubectl get pods -n restic-nginx"
p "#kubectl -n restic-nginx exec -it <pod_name> -- /bin/bash"

cmd

# cd var/log/nginx


random=$(openssl rand -hex 12)
pe "velero backup create $random --include-namespaces restic-nginx"

pe "velero backup logs $random | grep error"

pe "velero backup describe $random --details"