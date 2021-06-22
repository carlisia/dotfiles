#!/bin/bash

. ../../demo-magic.sh

pe "velero backup download acme-dev"
wait

pe "tree"
wait

pe "tar -xvf acme-dev-data.tar.gz"
wait

pe "tree | less"
wait

pe "rm -rf metadata/ resources/ acme-dev-data.tar.gz"