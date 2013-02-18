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
end
before(:deploy, :deploy_path_init)

task :deploy_submodules do
	run "cd #{deploy_to}/current; git submodule init; git submodule update"
end
after(:deploy, :deploy_submodules)
