#!/bin/bash

. ../demo-magic.sh

pe "kubectl -n nginx-example exec $(kubectl -n nginx-example get pod -o name|cut -d/ -f2) ls /home"
pe "kubectl -n nginx-example exec $(kubectl -n nginx-example get pod -o name|cut -d/ -f2) touch /home/SHANGHAI_IS_THE_BEST.txt"
pe "kubectl -n nginx-example exec $(kubectl -n nginx-example get pod -o name|cut -d/ -f2) ls /home"