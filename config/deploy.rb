# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, "QnA"
set :repo_url, "git@github.com:Kisamict/Q-A.git"
set :deploy_to, "/home/deployer/QnA"
set :deploy_user, 'deployer'

append :linked_files, "config/database.yml", 'config/master.key'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage", "bin"

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
