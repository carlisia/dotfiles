#!/bin/bash

. ../demo-magic.sh

random=$(openssl rand -hex 12)
pe "REGISTRY=carlisia VERSION=$random make update container push -C /Users/carlisia/work/src/github.com/heptio/velero/"

pe "kubectl -n velero set image deploy/velero velero=carlisia/velero:$random"

pe "kubectl -n velero set image daemonset/restic restic=carlisia/velero:$random"

pe "kubectl -n velero delete pods -l deploy=velero"



