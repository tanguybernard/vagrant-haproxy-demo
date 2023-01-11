#!/usr/bin/env bash
echo -e "Mis à jour des packages\n"
apt-get update -y -qq
echo -e "Installation HAProxy\n"
apt-get install -y haproxy > /dev/null 2>&1

echo -e "Activer HAProxy comme daemon au démarrage\n"
cat > /etc/default/haproxy <<EOF
ENABLED=1
EOF

echo -e "Configuration HAProxy\n"
cat > /etc/haproxy/haproxy.cfg <<EOF
global
 # global settings here
 log /dev/log local0
 log localhost local1 notice
 user haproxy
 group haproxy
 maxconn 2000
 daemon

defaults
 # defaults here
 log global
 mode http
 option httplog
 option dontlognull
 retries 3
 timeout connect 5000
 timeout client 50000
 timeout server 50000


frontend http-in
    bind 0.0.0.0:80
    acl appA_url url_beg /appA
    acl appB_url url_beg /appB
    use_backend app-a if appA_url
    use_backend app-b if appB_url

backend app-a
    balance roundrobin
    http-request set-uri %[url,regsub(^/appA,/,)] if { path_beg /appA }
    server server1 192.168.50.10:80 check maxconn 30

backend app-b
  balance roundrobin
  # strip the prefix '/appB' off of the path
  http-request set-uri %[url,regsub(^/appB,/,)] if { path_beg /appB }
  server server1 192.168.50.20:80 check maxconn 30
EOF

echo -e "Valider la configuration HAProxy \n"
haproxy -f /etc/haproxy/haproxy.cfg -c

echo -e "Demarrer HAProxy\n"
systemctl start haproxy
