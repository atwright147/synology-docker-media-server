#!/bin/sh
# Generate a read-only Gluetun API role and the matching qSticky secret.
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
auth_dir="$repo_dir/gluetun/auth"

if [ -s "$auth_dir/config.toml" ] && [ -s "$auth_dir/gluetun_apikey" ]; then
    echo "qSticky API credentials already exist; keeping them unchanged."
    exit 0
fi
if [ -e "$auth_dir/config.toml" ] || [ -e "$auth_dir/gluetun_apikey" ]; then
    echo "Incomplete qSticky credentials in $auth_dir; restore both files before continuing." >&2
    exit 1
fi

umask 077
api_key=$(openssl rand -hex 32)
mkdir -p "$auth_dir"
printf '%s\n' "$api_key" > "$auth_dir/gluetun_apikey"
cat > "$auth_dir/config.toml" <<EOF
[[roles]]
name = "qsticky"
routes = ["GET /v1/portforward", "GET /v1/vpn/status"]
auth = "apikey"
apikey = "$api_key"
EOF

echo "Created qSticky API credentials in $auth_dir."
