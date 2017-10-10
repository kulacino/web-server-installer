#!/bin/bash
#
# Script for Web Server Installation
# Date Created: 2017-10-09
# Version: webstackinstaller v1.0
# Author: Cynthia Ayu (cynthiayu)
#

# Start from here.

# Execute command as root (or sudo)
do_with_root() {
	if [[ `whoami` = 'root' ]]; then
		$*
	elif [[ -x /bin/sudo || -x /usr/bin/sudo ]]; then
		echo "sudo $*"
		sudo $*
	else
		echo "Packages requires root privileges to be installed."
		echo "Please run this script as root."
		exit 1
	fi
}

# Detect OS distribution
if [[ `which lsb_release 2>/dev/null` ]]; then
	# lsb_release available
	distro_name=`lsb_release -is`
else
	# lsb_release not available
	lsb_files=`find /etc -type f -maxdepth 1 \( ! -wholename /etc/os-release ! -wholename /etc/lsb-release -wholename /etc/\*release -o -wholename /etc/\*version \) 2> /dev/null`
	for file in $lsb_files; do
		if [[ $file =~ /etc/(.*)[-_] ]]; then
		distro_name=${BASH_REMATCH[1]}
		break
	else
		echo "Sorry, PackagesAutoInstall script is not compatible with your system."
		exit 1
	fi
	done
fi

echo "Detected system:" $distro_name

shopt -s nocasematch

# Installing WebServer Stack in Ubuntu based on $1 value
# $1 = lemp7, lamp7, lemp5, lamp5. Package will be installed based on $1 value

# Nginx with PHP7
if [[ $distro_name == "ubuntu" && $1 == "lemp7"  ]]; then
	echo "Installing LEMPHP7 stack now..."

	# Add PPA for PHP before installing
	echo "Adding PPA PHP now ..."
	add-apt-repository ppa:ondrej/php -y
	
	# Add stable PPA for Nginx
	echo "Adding PPA nginx now ..."
	add-apt-repository ppa:nginx/stable -y

	# Update Repository
	apt-get update	
	
	# Installing Nginx and PHP7
	apt-get -y install python-software-properties
	apt-get -y install nginx
	apt-get -y install php7.0-fpm php7.0-cli php7.0-common php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-curl php7.0-intl php7.0-xsl php7.0-mbstring php7.0-zip php7.0-bcmath php7.0-iconv php7.0-dev

	# Installing MySQL 5.7
	apt-get install -y mysql-server mysql-client

	# Enable Nginx services
	service nginx restart

	echo "LEMP7 installation is finished!"

# Apache with PHP7		
elif [[ $distro_name == "ubuntu" && $1 == "lamp7" ]]; then
	echo "Installing LAMPHP7 stack now..."

	# Add PPA for PHP before installing
	echo "Adding PPA PHP now ..."
	add-apt-repository ppa:ondrej/php -y
	apt-get update	

	# Installing Apache and PHP7
	apt-get install apache2 -y
	apt-get install php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-curl php7.0-intl php7.0-xsl php7.0-mbstring php7.0-zip php7.0-bcmath php7.0-iconv php7.0-fpm php7.0-dev -y

	# Installing MySQL
	apt-get install -y mysql-server mysql-client

	# Installing Redis 3.x
	#pecl install redis-3.1.2
	#phpenmod redis

	# Enable Module
	service apache2 restart
	a2enmod rewrite expires headers actions alias proxy proxy_fcgi setenvif
	a2enconf php7.0-fpm

	echo "LAMP7 installation is finished!"

# Apache with PHP5
elif [[ $distro_name == "ubuntu" && $1 == "lamp5" ]]; then
	echo "Installing Apache2 and PHP5 stack now..."

	# Add PPA for PHP before installing
	echo "Adding PPA PHP now ..."
	add-apt-repository ppa:ondrej/php -y
	apt-get update	

	# Installing Apache2 and PHP5
	apt-get install apache2 -y
	apt-get install php5.6 php5.6-common php5.6-gd php5.6-mysql php5.6-mcrypt php5.6-curl php5.6-intl php5.6-xsl php5.6-mbstring php5.6-zip php5.6-bcmath php5.6-iconv php5.6-fpm php5.6-dev -y

	# Installing MySQL
	apt-get install -y mysql-server mysql-client

	# Enable Module
	service apache2 restart
	a2enmod rewrite expires headers actions alias proxy proxy_fcgi setenvif
	a2enconf php5.6-fpm

	echo "LAMP5 installation is finished!"

# Nginx with PHP5
elif [[ $distro_name == "ubuntu" && $1 == "lemp5" ]]; then
	echo "Installing Nginx and PHP5 stack now..."

	# Add PPA for PHP before installing
	echo "Adding PPA PHP now ..."
	add-apt-repository ppa:ondrej/php -y
	
	# Add stable PPA for Nginx
	echo "Adding PPA nginx now ..."
	add-apt-repository ppa:nginx/stable -y

	# Update Repository
	apt-get update	
	
	# Installing Nginx and PHP7
	apt-get -y install python-software-properties
	apt-get -y install nginx
	apt-get -y install php5.6 php5.6-common php5.6-gd php5.6-mysql php5.6-mcrypt php5.6-curl php5.6-intl php5.6-xsl php5.6-mbstring php5.6-zip php5.6-bcmath php5.6-iconv php5.6-fpm php5.6-dev

	# Installing MySQL
	apt-get install -y mysql-server mysql-client

	# Enable Nginx services
	service nginx restart

	echo "LEMP5 installation is finished!"

# Installing WebServer Stack in CentOS based on $1 value
# $1 = lemp7, lamp7, lemp5, lamp5. Package will be installed based on $1 value

# Nginx with PHP7
elif [[ $distro_name == "centos" && $1 == "lemp7"  ]]; then
	echo "Installing LEMPHP7 stack now..."
	
	# Installing Nginx and PHP7
	yum -y install epel-release
	yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm
	yum -y update
	yum -y install nginx
	yum -y install php70w-fpm yum -y install php70u php70u-pdo php70u-mysqlnd php70u-opcache php70u-xml php70u-mcrypt php70u-gd php70u-devel php70u-mysql php70u-intl php70u-mbstring php70u-bcmath php70u-json php70u-iconv

	# Installing MySQL 5.7
	wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
	yum -y localinstall mysql57-community-release-el7-7.noarch.rpm

	# Start Nginx
	systemctl start nginx
	systemctl enable nginx
	service mysqld start

	echo "LEMP7 installation is finished!"

# Apache with PHP7		
elif [[ $distro_name == "centos" && $1 == "lamp7" ]]; then
	echo "Installing LAMPHP7 stack now..."

	# Installing Apache and PHP7
	yum -y install epel-release
	yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm
	yum -y update
	yum -y install httpd
	yum -y install php70w-fpm yum -y install php70u php70u-pdo php70u-mysqlnd php70u-opcache php70u-xml php70u-mcrypt php70u-gd php70u-devel php70u-mysql php70u-intl php70u-mbstring php70u-bcmath php70u-json php70u-iconv

	# Installing MySQL 5.7
	wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
	yum -y localinstall mysql57-community-release-el7-7.noarch.rpm

	# Start Apache
	service httpd start
	service mysqld start

	echo "LAMP7 installation is finished!"

# Nginx with PHP5
elif [[ $distro_name == "centos" && $1 == "lemp5"  ]]; then
	echo "Installing LEMPHP5 stack now..."
	
	# Installing Nginx and PHP5
	yum -y update
	yum -y install epel-release
	wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	wget https://centos7.iuscommunity.org/ius-release.rpm
	rpm -Uvh ius-release*.rpm
	yum -y update
	yum -y install nginx
	yum -y install php56u php56u-opcache php56u-xml php56u-mcrypt php56u-gd php56u-devel php56u-mysql php56u-intl php56u-mbstring php56u-bcmath

	# Installing MySQL 5.7
	wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
	yum -y localinstall mysql57-community-release-el7-7.noarch.rpm

	# Start Nginx
	systemctl start nginx
	systemctl enable nginx
	service mysqld start

	echo "LEMP5 installation is finished!"

# Apache with PHP5		
elif [[ $distro_name == "centos" && $1 == "lamp5" ]]; then
	echo "Installing LAMPHP5 stack now..."

	# Installing Apache and PHP5
	yum -y update
	yum -y install epel-release
	wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	wget https://centos7.iuscommunity.org/ius-release.rpm
	rpm -Uvh ius-release*.rpm
	yum -y update
	yum -y install httpd
	yum -y install php56u php56u-opcache php56u-xml php56u-mcrypt php56u-gd php56u-devel php56u-mysql php56u-intl php56u-mbstring php56u-bcmath

	# Installing MySQL 5.7
	wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
	yum -y localinstall mysql57-community-release-el7-7.noarch.rpm

	# Start Apache
	service httpd start
	service mysqld start

	echo "LAMP5 installation is finished!"

else
	# Wrong value
	echo "Sorry, plese specify your needed packages."
	echo "Please specify ./webstackinstaller.sh followed with lemp7, lemp5, lamp7, or lamp5 based on your needed web server stack."
	exit 1
fi
