#!/bin/bash

. ../demo-magic.sh

pe "kubectl -n nginx-example port-forward $(kubectl -n nginx-example get pod -o name|cut -d/ -f2) 8100:80"