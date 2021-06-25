#!/bin/bash

. ../demo-magic.sh

random=$(openssl rand -hex 12)
# pe "REGISTRY=carlisia VERSION=$random make update container push -C /Users/carlisia/work/src/github.com/heptio/velero/"

# pe "kubectl -n velero set image deploy/velero velero=carlisia/velero:$random"
pe "kubectl -n velero set image deploy/velero velero=carlisia/velero:a0a59ed29bc25720aac61ea0"

# pe "kubectl -n velero delete pods -l deploy=velero"




# kubectl -n velero set image deploy/velero velero=carlisia/velero:a0a59ed29bc25720aac61ea0