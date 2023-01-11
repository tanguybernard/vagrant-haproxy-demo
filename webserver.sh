
#!/usr/bin/env bash
APACHE_CONFIG=/etc/apache2/apache2.conf
LOCALHOST=localhost
apt-get update -y -qq
apt-get install -y apache2 > /dev/null 2>&1
echo -e " — Ajouter ServerName au fichier de configuration n"
grep -q "ServerName ${LOCALHOST}" "${APACHE_CONFIG}" || echo "ServerName ${LOCALHOST}" >> "${APACHE_CONFIG}"
echo -e " — Redemarre Apache web server\n"
service apache2 restart
echo -e " — Modification index.html file\n"
cat > /var/www/html/index.html <<EOD
<html>
<head>
<title>${HOSTNAME}</title>
</head>
<body>
<h1>${HOSTNAME}</h1>
<p>Je suis votre serviteur!</p>
</body>
</html>
EOD
