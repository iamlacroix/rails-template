require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
# load "config/recipes/mongodb"
load "config/recipes/postgresql"
# load "config/recipes/mysql"
# load "config/recipes/redis"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

server "ip.address.of.server", :web, :app, :db, primary: true

set :user, "deploy"
set :application, "application_name"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@lacroixdesign.net:application_name.git"
set :remote_repository, "origin" # default is "origin"
set :branch, "master" # default is "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases