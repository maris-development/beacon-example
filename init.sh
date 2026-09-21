#!/bin/bash

# PLUGIN_PARAMETERS is a Python dict literal, e.g. {'BEACON_ADMIN_PASSWORD': 'test'}.
# Parse it with python3 and write every key/value pair to a .env file next to this script.
script_dir="$(cd "$(dirname "$0")" && pwd)"

if [ -n "$PLUGIN_PARAMETERS" ]; then
    python3 - > "$script_dir/.env" <<'EOF'
import ast, os

params = ast.literal_eval(os.environ["PLUGIN_PARAMETERS"])
for key, value in params.items():
    print(f"{key}={value}")
EOF
fi

# Read the parameters into this shell.
if [ -f "$script_dir/.env" ]; then
    set -a
    . "$script_dir/.env"
    set +a
fi

conf=/etc/nginx/app-location-conf.d/beacon.conf

# Proxy all HTTPS traffic to the docker container on port 8080
cat > "$conf" <<'EOF'

location = /admin {
    return 301 /admin/;
}
EOF

# BEACON_SRC_ADMIN_AUTH=false gives the /admin/ path to the basic auth of Beacon.
if [ "${BEACON_SRC_ADMIN_AUTH:-true}" = "true" ]; then
    credentials="$(printf '%s:%s' "${BEACON_ADMIN_USERNAME:-admin}" "${BEACON_ADMIN_PASSWORD:-admin}" | base64 -w 0)"

    cat >> "$conf" <<EOF

location ^~ /admin/ {
    auth_request     /validate;
    auth_request_set \$username \$upstream_http_username;
    error_page 401 = @custom_401;

    proxy_set_header Host          \$host;
    proxy_set_header X-Real-IP     \$remote_addr;
    proxy_set_header X-Remote-User \$username;
    proxy_set_header Authorization "Basic $credentials";

    proxy_pass http://localhost:8080;
}
EOF
fi

cat >> "$conf" <<'EOF'

location / {
    proxy_pass http://localhost:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
EOF

nginx -t && systemctl restart nginx.service
