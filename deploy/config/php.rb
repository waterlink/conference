set :php_version, "5.3.21"
set :php_url, "http://ua2.php.net/distributions/php-#{php_version}.tar.gz"
set :php_prefix, "/opt/php"
set :php_config, "--prefix=#{php_prefix} --with-fpm-user=www-data --with-fpm-group=www-data --enable-fpm --enable-soap --with-mcrypt --enable-mbstring --with-openssl --with-kerberos --with-gd --with-jpeg-dir=/usr/lib --enable-gd-native-ttf --with-libxml-dir=/usr/lib --with-curl --enable-zip --enable-sockets --with-zlib --enable-exif --enable-ftp --with-iconv --with-gettext --enable-gd-native-ttf --with-freetype-dir=/usr"

set :php_fpm_port, "9000"

namespace :php do
	task :install_dependencies do
		run "#{sudo} apt-get update; #{sudo} aptitude -q -y install gcc libpcre++-dev libcurl4-openssl-dev libxml2-dev libjpeg-dev libpng-dev libxpm-dev libfreetype6-dev libmcrypt-dev libmysql++-dev autoconf libevent-dev"
	end

	desc "Installs php in prefix dir."
	task :install do
		run "cd /tmp; wget -c #{php_url}; tar -xf php-#{php_version}.tar.gz; cd php-#{php_version}; ./configure #{php_config} && make && #{sudo} make install"
		run "cd #{php_prefix}/etc; #{sudo} cp php-fpm.conf.default php-fpm.conf"
	end
	before "php:install", "php:install_dependencies"

	desc "Starts php-fpm server."
	task :start do
		run "#{sudo} /opt/php/sbin/php-fpm -c /opt/php/etc"
	end
end
