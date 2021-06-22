#!/bin/bash

. ../demo-magic.sh

# random=$(openssl rand -hex 12)
random=acme-dev
pe "velero backup create $random --include-namespaces nginx-example"
wait

pe "velero backup describe $random --details"
wait

pe "velero backup logs $random"

