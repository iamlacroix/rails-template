# Dir[File.join(File.dirname(__FILE__), 'mongodb/*.rb')].sort.each { |lib| require lib }

set_default(:mongodb_host, "localhost")
set_default(:mongodb_user) { application }
set_default(:mongodb_password) { Capistrano::CLI.password_prompt "MongoDB Password: " }
set_default(:mongodb_database) { "#{application}_production" }

namespace :mongodb do    
	desc "Installs mongodb via apt repository"
	task :install, :role => :app do
		run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
		run "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' >> /tmp/mongodb.list"
		run "#{sudo} cp /tmp/mongodb.list /etc/apt/sources.list.d/"
		run "rm /tmp/mongodb.list"
		run "#{sudo} apt-get -y update"
		run "#{sudo} apt-get -y install mongodb-10gen"
	end
	after "deploy:install", "mongodb:install"
	
	
	# Setup
	desc "Create a database for this application."
	task :create_database, roles: :db, only: {primary: true} do
		run "mongo #{mongodb_database} --eval 'db.addUser(\"#{mongodb_user}\", \"#{mongodb_password}\")'"
	end
	after "deploy:setup", "mongodb:create_database"
	
	
	# Create YML
	desc "Generate the mongoid.yml configuration file."
	task :setup, roles: :app do
		run "mkdir -p #{shared_path}/config"
		template "mongoid.yml.erb", "#{shared_path}/config/mongoid.yml"
	end
	after "deploy:setup", "mongodb:setup"
	after "mongodb:create_database", "mongodb:setup"
	
	
	# Symlink YML
	desc "Symlink mongoid.yml"
	task :symlink, roles: :app do
		run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
	end
	after "deploy:finalize_update", "mongodb:symlink"
	
	
	# Services
	desc "Starts the mongodb server"
	task :start, :role => :app do
		# sudo "#{mongodb_bin_path}/bin/mongod --fork --logpath #{mongodb_log} --logappend --dbpath #{mongodb_data_path}"
		run "#{sudo} sudo service mongodb start"
	end
	
	
	desc "Stop the mongodb server"
	task :stop, :role => :app do
		# pid = capture("ps -o pid,command ax | grep mongod | awk '!/awk/ && !/grep/ {print $1}'")
		# sudo "kill -INT #{pid}" unless pid.strip.empty?
		run "#{sudo} sudo service mongodb stop"
	end
	
	
	desc "Restart the mongodb server"
	task :restart, :role => :app do
		# pid = capture("ps -o pid,command ax | grep mongod | awk '!/awk/ && !/grep/ {print $1}'")
		# mongodb.stop unless pid.strip.empty?
		# mongodb.start
		run "#{sudo} sudo service mongodb restart"
	end
	after "deploy:setup", "mongodb:restart"
	
	
end