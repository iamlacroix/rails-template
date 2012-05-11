require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
# load "config/recipes/mongodb"
# load "config/recipes/postgresql"
load "config/recipes/mysql"
load "config/recipes/redis"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
# load "config/recipes/ruby" # No long necessary, Foreman does not need sudo for bundle exec
load "config/recipes/gitlab"
load "config/recipes/check"

server "50.56.200.141", :web, :app, :db, primary: true
set :environment, "production"

set :user, "deploy"
set :application, "gitlab"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@lacroixdesign.net:gitlab.git"
set :remote_repository, "origin" # default is "origin"
set :branch, "master" # default is "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases