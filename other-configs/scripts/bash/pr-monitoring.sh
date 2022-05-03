#!/usr/local/bin/bash

now=$(date +"%m_%d_%Y")
now=$(date +"%Y-%m-%d")
printf "📆 Last Run: %s\n" "${now}" > ~/repos-workflow/pr-monitoring.yaml
echo -e "🤓 PR Monitoring\n" >> ~/repos-workflow/pr-monitoring.yaml

echo -e "---\nReviews requested 🙏" >> ~/repos-workflow/pr-monitoring.yaml
until python3 -m gita shell gh pr list -s open --search "review-requested:@me" | /usr/local/bin/ag 'OPEN|DRAFT' >> ~/repos-workflow/pr-monitoring.yaml; do
	printf '.'
	sleep 5
done

# echo -e "---\nAssigned 👈" >> ~/repos-workflow/pr-monitoring.yaml
# until python3 -m gita shell gh pr list -s open --assignee "@me" | /usr/local/bin/ag 'OPEN|DRAFT' >> ~/repos-workflow/pr-monitoring.yaml; do
# 	printf '.'
# 	sleep 5
# done

# echo -e "---\nMentions 🎧" >> ~/repos-workflow/pr-monitoring.yaml
# until python3 -m gita shell gh pr list -s open --search "mentions:@me" | /usr/local/bin/ag 'OPEN|DRAFT' >> ~/repos-workflow/pr-monitoring.yaml; do
# 	printf '.'
# 	sleep 5
# done

# echo -e "---\nI commented on 👄" >> ~/repos-workflow/pr-monitoring.yaml
# until python3 -m gita shell gh pr list -s open --search "commenter:@me" | /usr/local/bin/ag 'OPEN|DRAFT' >> ~/repos-workflow/pr-monitoring.yaml; do
# 	printf '.'
# 	sleep 5
# done

# echo -e "---\nMine 💃" >> ~/repos-workflow/pr-monitoring.yaml
# until python3 -m gita shell gh pr list -s open --author "@me" | /usr/local/bin/ag 'OPEN|DRAFT' >> ~/repos-workflow/pr-monitoring.yaml; do
# 	printf '.'
# 	sleep 5
# done

echo -e "\ndone ✅" >> ~/repos-workflow/pr-monitoring.yaml

