#!/bin/bash

# Set environment variables for sensitive information
JIRA_URL="https://goldingcapital.atlassian.net/rest/api/3/project?expand=lead"
JIRA_USER="n.hysa@goldingcapital.com"
JIRA_TOKEN="--token--"

# Fetch projects from JIRA
curl --request GET \
  --url "$JIRA_URL" \
  --user "$JIRA_USER:$JIRA_TOKEN" \
  --header 'Accept: application/json' \
  -o projects.json

# Check if the curl command was successful
if [ $? -ne 0 ]; then
  echo "Failed to fetch projects from JIRA"
  exit 1
fi

# Parse JSON and convert to CSV if the file exists
if [ -f projects.json ]; then
  jq -r '["id", "key", "name", "projectTypeKey", "archived", "lead", "category"], (.[] | [.id, .key, .name, .projectTypeKey, .archived, .lead.displayName, .projectCategory.name]) | @csv' projects.json > jira_projects.csv
  rm projects.json
  echo "Projects have been exported to jira_projects.csv"
else
  echo "Failed to parse JSON: projects.json not found"
  exit 1
fi