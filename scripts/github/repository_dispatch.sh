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

if [ -z "$REPO" ]; then
  echo "Empty Token"
  exit 1
fi

PAYLOAD="$(jq -n --arg event_type "$EVENT_TYPE" '{"event_type": $event_type}')"

RESPONSE=$(
curl -s -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -w "%{http_code}" \
  https://api.github.com/repos/"$OWNER"/"$REPO"/dispatches \
  -d "$PAYLOAD"
)

if [ "$RESPONSE" != "204" ]; then
  echo "Error occurred when creating event, status code: $RESPONSE"
else
  echo "Event dispatch sent"
fi