#! \bin\bash
echo "welke server will je instaleren? apache of nginx?" 

read server

if [ $server = "apache" ] 
then 
sudo zypper install apache2
systemctl enable apache2 
systemctl start apache2

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-silfsigned.crt

elif [ $server = "nginx" ]
then
sudo zypper install nginx
sudo zypper refresh

systemctl enable nginx
systemctl start nginx

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-silfsigned.crt

else
echo "de geselecteerde server bestaat niet wil je het het script herladen? typ ja of nee" 
read opnieuwladen
while [ $opnieuwladen = "ja" ]
do
bash SrvInstall.sh
done
fi

sudo zypper refresh
sudo zypper install apache2 mariadb-server apache2-mod_php7 php7-gd php7-mysql php7-curl php7-mbstring php7-intl php7-gmp php7-bcmath php-imagick php7-xsl php7-zip
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo mysql -uroot -p
sudo /etc/init.d/mariadb start

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'P@ssw0rd';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;

quit;

wget https://download.nextcloud.com/server/releases/nextcloud-21.0.2.zip
sudo apt install unzip
unzip nextcloud-21.0.2.zip
sudo firewall-cmd --permanent --add-service=http --add-service=https
sudo firewall-cmd --reload
sudo vi /srv/www/htdocs/index.html
sudo chown --recursive wwwrun:wwwrun /srv/www/

sudo zypper install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo " einde van het script, wil je het script herladen? typ ja of nee" 
read opnieuwladen
while [ $opnieuwladen = "ja" ]
do
bash SrvInstall.sh
done


