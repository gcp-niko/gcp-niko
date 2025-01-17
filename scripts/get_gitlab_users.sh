#!/bin/bash

GITLAB_URL="https://gitlab.goldingcapital.com"
GITLAB_PRIVATE_TOKEN="--token--"
OUTPUT_FILE="gitlab_users.csv"

# Function to fetch users from GitLab API
fetch_users() {
    local page=1
    local per_page=100
    local users=()

    while : ; do
        response=$(curl -s --header "Private-Token: $GITLAB_PRIVATE_TOKEN" "$GITLAB_URL/api/v4/users?page=$page&per_page=$per_page")
        user_count=$(echo "$response" | jq '. | length')

        if [ "$user_count" -eq 0 ]; then
            break
        fi

        users+=("$response")
        page=$((page + 1))
    done

    echo "${users[@]}" | jq -s 'add'
}

# Fetch users and create CSV
users=$(fetch_users)
echo "$users" | jq -r '.[] | [.id, .username, .name, .state, .email, .state == "blocked", .state == "deactivated"] | @csv' > "$OUTPUT_FILE"

# Add header to CSV
sed -i '1iID,Username,Name,State,Email,Blocked,Deactivated' "$OUTPUT_FILE"

echo "CSV file created: $OUTPUT_FILE"