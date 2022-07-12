#!/usr/local/bin/bash

# gita super net checkout main
# gita fetch net
# gita pull net


# # knative/serving
# NETWORKING_DIR=$(dirname "$(find /Users/carlisiac/working/src/github.com/knative -name OWNERS | xargs grep -rl 'area/networking')" | xargs)
# for i in $NETWORKING_DIR; do pushd serving > /dev/null || exit; git log --author="carlisia" --pretty=format:"%ad,%h,%an" --date=short -- "$i"; popd > /dev/null || exit; done  | sort -u | cut -f1,3 -d, > serving.raw.txt

# knative-sandbox/net* and knative/networking
# # for i in net*; do pushd $i > /dev/null ; git log --pretty=format:"%ad,%an" --date=short; popd > /dev/null ; done > repo-net.raw.txt
all_paths=()
# allRepoNames=( "$(gita group ll net)" )
read -r -a all_repo_names < <(gita group ll net)

for i in "${all_repo_names[@]}"
do
    # echo "$i"
    all_paths+=( "$(gita ls "$i")" )
    # all_paths=( "$(gita ls "$i")" )
done


now=$(date +"%m_%d_%Y")
now=$(date +"%Y-%m-%d")
printf "📆 Last Run: %s\n" "${now}" > ~/repos-workflow/prs-reviewed.yaml
echo -e "🤓 PRs Reviewed\n" >> ~/repos-workflow/prs-reviewed.yaml

echo -e "---\nPRs Reviewed (｡◕‿◕｡)" >> ~/repos-workflow/prs-reviewed.yaml
for i in "${all_paths[@]}"
do
    pushd "$i" > /dev/null || exit;
    printf '\n%s:\n' "$(git remote show origin -n | grep "Fetch URL:" | sed -E "s#^.*/(.*)#\1#" | sed "s#.git##")";
    # git log --graph "$(git describe --abbrev=0 --tags).." --first-parent --oneline  \
    # --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)';
    # gh pr list -s merged --search "commenter:@me approve in:comments -author:@me -author:knative-automation"
gh pr list -s open --search " -author:@me -author:knative-automation  -label:size/XS -label:size/S" --json author,title,assignees,author,createdAt,updatedAt,headRepository,mergedAt,number,url,state,labels | tee /tmp/ins |
    jq '
    [.[] |
    {
        lastupdate: (if .updatedAt == null then "" else (.updatedAt | strptime("%Y-%m-%dT%H:%M:%SZ") | todate[0:10]) end),
        created:  (if .createdAt == null then "" else (.createdAt | strptime("%Y-%m-%dT%H:%M:%SZ") | todate[0:10]) end ),
     number: .number,
        author: .author.login,
      title: .title,
      labels: [.labels[].name] | join(", "),
        url: .url,
    }
    ] | sort_by(.updatedAt)   ' | jtbl -m
    printf '\n';
    popd > /dev/null || exit;

done >> ~/repos-workflow/prs-reviewed.yaml

echo -e "\n\ndone ✅" >> ~/repos-workflow/prs-reviewed.yaml

# summary
# TODO: Replace start date.
# cat -- *.raw.txt | awk -F',' '$0 >= "2021-12-01"'  | cut -f2 -d, | sort | uniq -c  | sort -k1 -n -r
cat ~/repos-workflow/prs-reviewed.yaml