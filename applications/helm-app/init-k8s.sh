#!/usr/bin/env bash

set -e  # Stop Script on Error

# save all env for debugging
# printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

apt-get update -y

echo '==> Install nginx'
apt-get install nginx -y


echo '==> Configure nginx'
cd /etc/nginx/sites-available/
cp default default.backup  # backup default config

cat << EOF > ./default
server {
    listen 80;
    server_name _;

    location = / {
        return 302 http://${REDIRECT};
    }
    location / {
        return 302 http://${REDIRECT}\$request_uri;
    }

}
EOF
# restart nginx
echo '==> Restart nginx'
service nginx restart 

exit 0
