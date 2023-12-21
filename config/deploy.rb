# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, "QnA"
set :repo_url, "git@github.com:Kisamict/Q-A.git"
set :deploy_to, "/home/deployer/QnA"
set :deploy_user, 'deployer'
set :default_env, {
  'NODE_ENV' => 'production',
  'PATH' => "$HOME/.nvm/versions/node/v16.20.2/bin:$PATH"
}

set :rbenv_type, :user
set :rbenv_ruby, '3.2.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

append :linked_files, "config/database.yml", 'config/master.key'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
