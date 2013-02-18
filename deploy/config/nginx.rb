set :nginx_version, "1.2.7"
set :nginx_url, "http://nginx.org/download/nginx-#{nginx_version}.tar.gz"
set :nginx_prefix, "/opt/nginx"
set :nginx_config, "--prefix=#{nginx_prefix} --user=www-data --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --with-http_stub_status_module --with-http_ssl_module --with-http_dav_module --with-http_gzip_static_module"

namespace :nginx do
	task :install_dependencies do
		run "#{sudo} apt-get update; #{sudo} aptitude -q -y install libc6 libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libssl-dev zlib1g zlib1g-dev lsb-base"
	end

	desc "Installs nginx in prefix dir."
	task :install do
		run "cd /tmp; wget -c #{nginx_url}; tar -xf nginx-#{nginx_version}.tar.gz; cd nginx-#{nginx_version}; ./configure #{nginx_config} && make && #{sudo} make install"
	end
	before "nginx:install", "nginx:install_dependencies"

	desc "Starts nginx server."
	task :start do
		run "#{sudo} /opt/nginx/sbin/nginx"
	end

	desc "Reloads nginx server."
	task :reload do
		run "#{sudo} /opt/nginx/sbin/nginx -s reload || #{sudo} /opt/nginx/sbin/nginx"
	end

	desc "Configures nginx server."
	task :configure do
		nginx_conf = ERB.new File.read("templates/nginx.conf.erb")
		put nginx_conf.result(binding), ".nginx.conf"
		run "#{sudo} cp .nginx.conf #{nginx_prefix}/conf/nginx.conf"
		put File.read("templates/fastcgi_params"), ".fastcgi_params"
		run "#{sudo} cp .fastcgi_params #{nginx_prefix}/conf/fastcgi_params"
		run "#{sudo} mkdir -p #{nginx_prefix}/conf/conf.d"
		run "#{sudo} mkdir -p #{nginx_prefix}/conf/sites-available"
		run "#{sudo} mkdir -p #{nginx_prefix}/conf/sites-enabled"
	end
	after "nginx:configure", "nginx:reload"
end
