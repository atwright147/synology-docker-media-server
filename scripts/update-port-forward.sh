#!/bin/sh

QB_USERNAME=${QB_USERNAME:-admin}
QB_PASSWORD=${QB_PASSWORD:-adminadmin}
QB_HOST=${QB_HOST:-http://localhost:8080}
GLU_TUN_API=${GLU_TUN_API:-http://localhost:8000}

# Get port from argument or query gluetun control server API
if [ -n "$1" ] && [ "$1" != "0" ]; then
    PORT=$1
else
    PORT=$(wget -qO- "$GLU_TUN_API/v1/portforward" 2>/dev/null \
        | grep -o '"port":[0-9]*' | head -1 | grep -o '[0-9]*')
fi

[ -z "$PORT" ] || [ "$PORT" = "0" ] && exit 0

COOKIE_FILE=$(mktemp /tmp/qb_cookies.XXXXXX)

curl -s -c "$COOKIE_FILE" \
    -d "username=$QB_USERNAME&password=$QB_PASSWORD" \
    "$QB_HOST/api/v2/auth/login" > /dev/null

curl -s -b "$COOKIE_FILE" \
    -H "Referer: $QB_HOST/" \
    --data-urlencode "json={\"listen_port\": $PORT}" \
    "$QB_HOST/api/v2/app/setPreferences" > /dev/null

rm -f "$COOKIE_FILE"
