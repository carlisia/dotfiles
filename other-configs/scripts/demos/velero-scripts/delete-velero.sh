#!/bin/bash

. demo-magic.sh

pe "kubectl delete namespace/velero clusterrolebinding/velero"
pe "kubectl delete crds -l component=velero"
pe "kubectl delete ns nginx-example"