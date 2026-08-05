#!/bin/sh

PORT=${1:-0}
QB_USERNAME=${QB_USERNAME:-admin}
QB_PASSWORD=${QB_PASSWORD:-adminadmin}
QB_HOST=${QB_HOST:-http://localhost:8080}

COOKIE_FILE=$(mktemp /tmp/qb_cookies.XXXXXX)

curl -s -c "$COOKIE_FILE" \
    -d "username=$QB_USERNAME&password=$QB_PASSWORD" \
    "$QB_HOST/api/v2/auth/login" > /dev/null

curl -s -b "$COOKIE_FILE" \
    --data-urlencode "json={\"listen_port\": $PORT}" \
    "$QB_HOST/api/v2/app/setPreferences" > /dev/null

rm -f "$COOKIE_FILE"
