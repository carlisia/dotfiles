#!/bin/bash

now=$(date +"%m_%d_%Y")
now=$(date +"%Y-%m-%d")
printf "📆 Last Run: %s\n" "${now}" > ~/repos-workflow/prs-reviewed.yaml
echo -e "🤓 PRs Reviewed\n" >> ~/repos-workflow/prs-reviewed.yaml

echo -e "---\nPRs Reviewed (｡◕‿◕｡)" >> ~/repos-workflow/prs-reviewed.yaml
until python3 -m gita shell 'gh pr list -s merged --search "commenter:@me approve in:comments -author:@me -author:knative-automation"' | /usr/local/bin/ag 'MERGED' >> ~/repos-workflow/prs-reviewed.yaml; do
	printf '.'
	sleep 5
done

echo -e "\ndone ✅" >> ~/repos-workflow/prs-reviewed.yaml

# https://cli.github.com/manual/gh_help_formatting


