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

# Proxy all HTTPS traffic to the docker container on port 8080
cat > /etc/nginx/app-location-conf.d/beacon.conf <<'EOF'
location / {
    proxy_pass http://localhost:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
EOF

nginx -t && systemctl restart nginx.service