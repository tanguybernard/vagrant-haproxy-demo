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
 # a frontend that accepts requests from clients
 bind *:80
 default_backend webservers

backend webservers
 # servers that fulfill the requests
 balance roundrobin
 stats enable
 stats auth admin:admin
 stats uri /haproxy?stats
 option httpchk
 option forwardfor
 option http-server-close
 server webserver1 192.168.50.10:80 check
 server webserver2 192.168.50.20:80 check
EOF

echo -e "Valider la configuration HAProxy \n"
haproxy -f /etc/haproxy/haproxy.cfg -c

echo -e "Demarrer HAProxy\n"
systemctl start haproxy
