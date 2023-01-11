# Vagrant haproxy


## Install

vagrant up

## Show status

http://192.168.50.30/haproxy?stats

admin/admin


## Status haproxy

    systemctl status haproxy

## haproxy.sh

Une fois sur deux sur backA ou backB

## haproxy2.sh

redirige 192.168.50.30/appA sur le server1 est enleve appA

redirige 192.168.50.30/appB sur le server2 est enleve appB

## Haproxy conf


    1- User sends a request to http://site.com/appA
    2- haproxy redirect http to https
    3- haproxy choose backend
    4- haproxy needs to remove /appA from path and sends the request to backend .
    
    frontend http-in
        bind 0.0.0.0:80
        http-request redirect scheme https
        default_backend maintenance
    
    frontend https-in
        bind 0.0.0.0:443 ssl crt /etc/haproxy/certs alpn h2,http/1.1
        http-request add-header X-Forwarded-Proto https
        acl appA_url url_beg /appA
        use_backend appA if appA_url
        default_backend maintenance
    
    backend appA
        balance roundrobin
        http-request set-uri %[url,regsub(^/appA,/,)] if { path_beg /appA }
        server web1 127.0.0.1:5001 check

    backend maintenance
        balance roundrobin

## Credits

vagrant + haproxy 

https://medium.com/@deryrahman/haproxy-load-balancer-with-vagrant-5820a6eb8d06

https://dmaodo.medium.com/vagrant-et-haproxy-b366a9518dac

haproxy conf

https://www.haproxy.com/fr/blog/the-four-essential-sections-of-an-haproxy-configuration/

haproxy Base Path routing

https://www.haproxy.com/fr/blog/path-based-routing-with-haproxy/

Haproxy rewrite

https://discourse.haproxy.org/t/how-to-make-haproxys-ssl-redirect-and-path-rewrite-with-reqrep-work-at-the-same-time/2677/2
