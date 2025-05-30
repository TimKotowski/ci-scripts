#!/bin/bash
if [ -z "$TOKEN" ]; then
  echo "Empty Token"
  exit 1
fi

if [ -z "$EVENT_TYPE" ]; then
  echo "Empty Token"
  exit 1
fi

if [ -z "$OWNER" ]; then
  echo "Empty Token"
  exit 1
fi

if [ -z "$ID" ]; then
  echo "Empty ID"
  exit 1
fi

# Store this else where eventually
declare -a REPOS=("schema-registry-go")

PAYLOAD="$(jq -n --arg event_type "$EVENT_TYPE" --arg id "$ID" '{"event_type": $event_type, "client_payload": {"id": $id } }')"

for repo in "${REPOS[@]}"
do
RESPONSE=$(
curl -s -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -w "%{http_code}" \
  https://api.github.com/repos/"$OWNER"/"$repo"/dispatches \
  -d "$PAYLOAD"
)

if [ "$RESPONSE" != "204" ]; then
  echo "Error occurred when creating event for repo $repo, status code: $RESPONSE"
  exit 1
else
  echo "Event dispatch sent"
fi
done
