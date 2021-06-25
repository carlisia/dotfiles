#!/bin/bash

# VELEROPATH must be set. Please replace other command values directly in the script (ie bucket, region, secret, etc)


if [[ -z "${ITERATIONS}" ]]; then
    ITERATIONS=20
fi

# VELEROPATH=/Users/carlisiac/Documents/carlisia/velero-releases/velero-v1.6.0-rc.1-darwin-amd64

VELEROPATH=/Users/carlisiac/work/src/github.com/vmware-tanzu/velero/_output/bin/darwin/amd64
echo "=========>> About to iterate ${ITERATIONS} times"

# run make local first

for (( x=1 ; x <= ${ITERATIONS}; x++ )) 
    do 
        echo "iteration number: $x"
        echo "=========>> Install Velero"
        ${VELEROPATH}/velero install --provider aws --bucket c-aws-velero-bucket --backup-location-config region=us-west-2 --secret-file ~/creds/credentials-velero-aws --plugins velero/velero-plugin-for-aws:v1.2.0 --use-volume-snapshots=false --wait > /dev/null

        # v install --provider aws --bucket c-aws-velero-bucket --backup-location-config region=us-west-2 --secret-file ~/creds/credentials-velero-aws --plugins velero/velero-plugin-for-aws:v1.2.0 --use-volume-snapshots=false --wait


        echo "=========>> Uninstall Velero"
        ${VELEROPATH}/velero uninstall --force --wait > /dev/null

        # v uninstall --force --wait

    done