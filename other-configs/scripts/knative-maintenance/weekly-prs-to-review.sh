#!/usr/local/bin/bash

all_paths=()
read -r -a all_repo_names < <(gita group ll net)

for i in "${all_repo_names[@]}"
do
    all_paths+=( "$(gita ls "$i")" )
done

now=$(date +"%m_%d_%Y")
printf "📆 Ran on: %s\n" "${now}"
echo -e "🤓 Large PRs to review - weekly (｡◕‿◕｡)\n"
for i in "${all_paths[@]}"
do
    pushd "$i" > /dev/null || exit;
    printf '%s\n' "$(git remote show origin -n | grep "Fetch URL:" | sed -E "s#^.*/(.*)#\1#" | sed "s#.git##")";
    gh pr list -s open --search "-author:@me -author:knative-automation  -label:size/XS -label:size/S" --json author,title,assignees,author,createdAt,updatedAt,headRepository,mergedAt,number,url,state,labels | tee /tmp/ins |
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
    ] | sort_by("lastupdate")' | jtbl -m
    printf '\n';
    popd > /dev/null || exit;
done

echo -e "\n\ndone ✅"
