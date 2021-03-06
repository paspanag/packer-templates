#!/bin/bash

#rpm -Uvh http://mirror.webtatic-archive.com/yum/centos/5/latest.rpm
rpm -Uvh http://mirror.webtatic.com/yum/el5/latest.rpm

#MYSQLNEW=$(cat <<EOF
#[mysql56-community]
#name=MySQL 5.6 Community Server
#baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/5/$basearch/
#enabled=1
#gpgcheck=1
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
#EOF
#)

#echo "${MYSQLNEW}" >> /etc/yum.repos.d/mysql-community.repo

yum install -y httpd

/usr/sbin/groupadd mysql
/usr/sbin/useradd -g mysql -d /var/lib/mysql -s /bin/false mysql

wget http://repo.mysql.com/RPM-GPG-KEY-mysql -O /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql --no-check-certificate

wget http://dev.mysql.com/get/mysql-community-release-el5-5.noarch.rpm
yum localinstall -y --nogpg mysql-community-release-el5-5.noarch.rpm
yum install -y mysql-community-server
yum install -y mysql-community-devel mysql-community-libs

yum install -y libXrender
yum install -y libXext
yum install -y fontconfig
yum install -y urw-fonts

yum --enablerepo=webtatic-el5 -y install php54w
yum --enablerepo=webtatic-el5 -y install php54w-mysql
yum --enablerepo=webtatic-el5 -y install php54w-gd
yum --enablerepo=webtatic-el5 -y install php54w-pecl-xdebug
yum --enablerepo=webtatic-el5 -y install php54w-mbstring

VHOST=$(cat <<EOF
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	DocumentRoot "/var/www/html/web"
	DirectoryIndex index.php
	<Directory "/var/www/html/web">
		AllowOverride All
		Order allow,deny
		Allow from All
	</Directory>

	Alias /sf /var/www/html/lib/vendor/symfony/data/web/sf
	<Directory "/var/www/html/lib/vendor/symfony/data/web/sf">
                AllowOverride All
                Order allow,deny
                Allow from All
	</Directory>
</VirtualHost>
EOF
)

PHP=$(cat <<EOF
[PHP]
engine = On
zend.ze1_compatibility_mode = Off
short_open_tag = On
asp_tags = Off
precision    =  14
y2k_compliance = On
output_buffering = 4096
zlib.output_compression = Off
implicit_flush = Off
unserialize_callback_func=
serialize_precision = 100
allow_call_time_pass_reference = Off
safe_mode = Off
safe_mode_gid = Off
safe_mode_include_dir =
safe_mode_exec_dir =
safe_mode_allowed_env_vars = PHP_
safe_mode_protected_env_vars = LD_LIBRARY_PATH
disable_functions =
disable_classes =
expose_php = On
max_execution_time = 30
max_input_time = 60
memory_limit = -1
error_reporting  =  E_ALL
display_errors = Off
display_startup_errors = Off
log_errors = On
log_errors_max_len = 1024
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On
track_errors = Off
variables_order = "EGPCS"
register_globals = Off
register_long_arrays = Off
register_argc_argv = Off
auto_globals_jit = On
post_max_size = 100M
magic_quotes_gpc = Off
magic_quotes_runtime = Off
magic_quotes_sybase = Off
auto_prepend_file =
auto_append_file =
default_mimetype = "text/html"
doc_root =
user_dir =
enable_dl = On
file_uploads = On
upload_max_filesize = 100M
allow_url_fopen = On
allow_url_include = Off
default_socket_timeout = 60
[Date]
date.timezone = America/Edmonton
[filter]
[iconv]
[sqlite]
[xmlrpc]
[Pcre]
[Syslog]
define_syslog_variables  = Off
[mail function]
SMTP = localhost
smtp_port = 25
sendmail_path = /usr/sbin/sendmail -t -i
[SQL]
sql.safe_mode = Off
[ODBC]
odbc.allow_persistent = On
odbc.check_persistent = On
odbc.max_persistent = -1
odbc.max_links = -1
odbc.defaultlrl = 4096
odbc.defaultbinmode = 1
[MySQL]
mysql.allow_persistent = On
mysql.max_persistent = -1
mysql.max_links = -1
mysql.default_port =
mysql.default_socket =
mysql.default_host =
mysql.default_user =
mysql.default_password =
mysql.connect_timeout = 60
mysql.trace_mode = Off
[MySQLi]
mysqli.max_links = -1
mysqli.default_port = 3306
mysqli.default_socket =
mysqli.default_host =
mysqli.default_user =
mysqli.default_pw =
mysqli.reconnect = Off
[mSQL]
msql.allow_persistent = On
msql.max_persistent = -1
msql.max_links = -1
[PostgresSQL]
pgsql.allow_persistent = On
pgsql.auto_reset_persistent = Off
pgsql.max_persistent = -1
pgsql.max_links = -1
pgsql.ignore_notice = 0
pgsql.log_notice = 0
[Sybase]
sybase.allow_persistent = On
sybase.max_persistent = -1
sybase.max_links = -1
sybase.min_error_severity = 10
sybase.min_message_severity = 10
sybase.compatability_mode = Off
[Sybase-CT]
sybct.allow_persistent = On
sybct.max_persistent = -1
sybct.max_links = -1
sybct.min_server_severity = 10
sybct.min_client_severity = 10
[bcmath]
bcmath.scale = 0
[browscap]
[Informix]
ifx.default_host =
ifx.default_user =
ifx.default_password =
ifx.allow_persistent = On
ifx.max_persistent = -1
ifx.max_links = -1
ifx.textasvarchar = 0
ifx.byteasvarchar = 0
ifx.charasvarchar = 0
ifx.blobinfile = 0
ifx.nullformat = 0
[Session]
session.save_handler = files
session.save_path = "/var/lib/php/session"
session.use_cookies = 1
session.name = PHPSESSID
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_path = /
session.cookie_domain =
session.cookie_httponly =
session.serialize_handler = php
session.gc_probability = 1
session.gc_divisor     = 1000
session.gc_maxlifetime = 1440
session.bug_compat_42 = 0
session.bug_compat_warn = 1
session.referer_check =
session.entropy_length = 0
session.entropy_file =
session.cache_limiter = nocache
session.cache_expire = 180
session.use_trans_sid = 0
session.hash_function = 0
session.hash_bits_per_character = 5
url_rewriter.tags = "a=href,area=href,frame=src,input=src,form=fakeentry"
[MSSQL]
mssql.allow_persistent = On
mssql.max_persistent = -1
mssql.max_links = -1
mssql.min_error_severity = 10
mssql.min_message_severity = 10
mssql.compatability_mode = Off
mssql.secure_connection = Off
[Assertion]
[COM]
[mbstring]
[FrontBase]
[gd]
[exif]
[Tidy]
tidy.clean_output = Off
[soap]
soap.wsdl_cache_enabled=1
soap.wsdl_cache_dir="/tmp"
soap.wsdl_cache_ttl=86400
EOF
)

mkdir -p /etc/httpd/conf/

echo "${VHOST}" >> /etc/httpd/conf/httpd.conf
echo "${PHP}" > /etc/php.ini

sed -i "s/,STRICT_TRANS_TABLES//g" /etc/my.cnf

/sbin/service mysqld start
/sbin/service httpd start
/sbin/chkconfig mysqld on
/sbin/chkconfig httpd on


echo "Waiting for MySQL to be initialized"
sleep 30

wget -q http://192.168.1.103:8080/job/MySQLFetch/lastSuccessfulBuild/artifact/ppadmin.sql
#tar -zxvf mysql_db.tar.gz

BACKUPSQL=`echo *.sql`

/usr/bin/mysqladmin -u root password 'Swwsa4oAaNBbLH5Hm9ZhlDoqy33xSxy3'
/usr/bin/mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;" -pSwwsa4oAaNBbLH5Hm9ZhlDoqy33xSxy3
/usr/bin/mysql -uroot -pSwwsa4oAaNBbLH5Hm9ZhlDoqy33xSxy3 -e"CREATE DATABASE ppemployee;"
/usr/bin/mysql -uroot -pSwwsa4oAaNBbLH5Hm9ZhlDoqy33xSxy3 -P3306 ppemployee < $BACKUPSQL

#rm -rf mysql_db.tar.gz
rm -rf *.sql
