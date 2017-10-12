# web-server-installer
A simple script to install various web server stack based on linux distribution. This script only running under Ubuntu based, or CentOS 7.

**Usage Suggestions:**
Execute the script using sudo or using root user.
```
$ sudo ./web-server-installer.sh $1
```
$1 = lemp7 (nginx with php-fpm7), lemp5 (nginx with php-fpm5), lamp7 (apache2 with php-fpm7), and lamp5 (apache2 with php-fpm5)

*Example: Installing nginx with php7*
```
$ sudo ./web-server-installer.sh lemp7
```
The script will detect your operating system distro and then execute the command after detecting lsb_release.
