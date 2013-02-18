default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true

load 'config/php'
load 'config/nginx'


set :application, "conference"

set :scm, :git
set :repository,  "git@github.com:waterlink/conference.git"
set :deploy_to, "/var/www/#{application}"
set :branch, "master"

role :web, "localhost"
role :app, "localhost"

task :deploy_path_init do
	run "#{sudo} mkdir -p #{deploy_to}"
	run "#{sudo} chown -R `whoami` #{deploy_to}"
	run "#{sudo} chgrp -R www-data #{deploy_to}"
	run "#{sudo} usermod -a -G www-data www-data"
	run "#{sudo} usermod -a -G www-data root"
	run "#{sudo} usermod -a -G www-data `whoami`"
	run "#{sudo} chmod -R 777 #{deploy_to}"
	run "#{sudo} chmod 777 #{deploy_to}/.."
end
before :deploy, :deploy_path_init

task :deploy_submodules do
	run "cd #{deploy_to}/current; git submodule init; git submodule update"
end
after :deploy, :deploy_submodules

desc "Configures nginx config for this application."
task :setup_nginx_site do
	site_conf = ERB.new File.read("templates/#{application}.conf.erb")
	put site_conf.result(binding), ".#{application}.conf"
	run "#{sudo} cp .#{application}.conf #{nginx_prefix}/conf/sites-available/#{application}.conf"
	run "#{sudo} ln -s #{nginx_prefix}/conf/sites-available/#{application}.conf #{nginx_prefix}/conf/sites-enabled/#{application}.conf; true"
end
after :setup_nginx_site, "nginx:reload"
