#!/usr/local/bin/bash

# git clone https://github.com/knative/serving.git

# git clone https://github.com/knative/networking.git
# git clone https://github.com/knative-sandbox/net-istio.git
# git clone https://github.com/knative-sandbox/net-contour.git
# git clone https://github.com/knative-sandbox/net-http01.git
# git clone https://github.com/knative-sandbox/net-certmanager.git
# git clone https://github.com/knative-sandbox/net-kourier.git
# git clone https://github.com/knative-sandbox/net-gateway-api.git

# knative/serving
NETWORKING_DIR=$(dirname $(find . -name OWNERS | xargs grep -rl 'area/networking') | xargs)
printf "NETWORKING_DIR is... %s \n\n" "$NETWORKING_DIR"

for i in $NETWORKING_DIR; do
    printf "i is... %s \n" "$i"
    pushd serving > /dev/null; git log --pretty=format:"%ad,%h,%an" --date=short -- $i; popd > /dev/null;

done  | sort -u | cut -f1,3 -d, > serving.raw.txt

# knative-sandbox/net* and knative/networking
for i in net*; do pushd $i > /dev/null ; git log --pretty=format:"%ad,%an" --date=short; popd > /dev/null ; done > repo-net.raw.txt

# summary
# TODO: Replace start date.
cat *.raw.txt | awk -F',' '$0 >= "2021-12-01"'  | cut -f2 -d, | sort | uniq -c  | sort -k1 -n -r