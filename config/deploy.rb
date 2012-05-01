require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/mongodb"
# load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

server "50.56.191.114", :web, :app, :db, primary: true

set :user, "deploy"
set :application, "flyby"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@lacroixdesign.net:flyby-rackspace.git"
set :remote_repository, "server" # default is "origin"
set :branch, "rackspace" # default is "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases