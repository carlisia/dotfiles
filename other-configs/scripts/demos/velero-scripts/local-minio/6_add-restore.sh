#!/bin/bash

. ../demo-magic.sh

random=$(openssl rand -hex 12)
pe "velero restore create $random --from-backup acme-dev"
wait

pe "velero restore describe $random --details"
# wait

# pe "velero backup logs $random"

