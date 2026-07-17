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

# Define the Nginx configuration file path
nginx_conf="/etc/nginx/conf.d/tls_main.conf"

# Let Nginx serve the docker container running on port 8080 instead of a static web page
sed -i 's|root /var/www/html;|location \/ {\n    \tproxy_pass http:\/\/localhost:8080;\n    \tproxy_set_header Host $host;\n    \tproxy_set_header X-Real-IP $remote_addr;\n    }|' "$nginx_conf"
sed -i 's|index index.html index.htm;||' "$nginx_conf"

systemctl restart nginx.service

