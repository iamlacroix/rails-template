require 'erb'


namespace :mysql do
	
	desc <<-EOF
	Performs a compressed database dump. \
	WARNING: This locks your tables for the duration of the mysqldump.
	Don't run it madly!
	EOF
	task :dump, :roles => :db, :only => { :primary => true } do
		prepare_from_yaml
		run "mysqldump --user=#{db_user} -p --host=#{db_host} #{db_name} | bzip2 -z9 > #{db_remote_file}" do |ch, stream, out|
			ch.send_data "#{db_pass}\n" if out =~ /^Enter password:/
			puts out
		end
	end
	
	
	desc "Restores the database from the latest compressed dump"
	task :restore, :roles => :db, :only => { :primary => true } do
		prepare_from_yaml
		run "bzcat #{db_remote_file} | mysql --user=#{db_user} -p --host=#{db_host} #{db_name}" do |ch, stream, out|
			ch.send_data "#{db_pass}\n" if out =~ /^Enter password:/
			puts out
		end
	end
	
	
	desc "Downloads the compressed database dump to this machine"
	task :fetch_dump, :roles => :db, :only => { :primary => true } do
		prepare_from_yaml
		download db_remote_file, db_local_file, :via => :scp
	end
	
	
	desc "Installs MySQL via apt-get"
	task :install, role: :db do
		run "#{sudo} apt-get -y update"
		run "#{sudo} apt-get -y install mysql-server"
	end
	after "deploy:install", "mysql:install"
	
	
	desc "Create MySQL database and user for this environment using prompted values"
	task :setup, :roles => :db, :only => { :primary => true } do
		prepare_for_db_command

		sql = <<-SQL
		CREATE DATABASE #{db_name};
		GRANT ALL PRIVILEGES ON #{db_name}.* TO #{db_user}@localhost IDENTIFIED BY '#{db_pass}';
		SQL

		run "mysql --user=#{db_admin_user} -p --execute=\"#{sql}\"" do |channel, stream, data|
			if data =~ /^Enter password:/
				pass = Capistrano::CLI.password_prompt "Enter database password for '#{db_admin_user}':"
				channel.send_data "#{pass}\n" 
			end
		end
	end
	after "deploy:setup", "mysql:setup"
	
	
	desc "Create database.yml in shared path with settings for current stage and test env"
	task :create_yaml do      
		set(:db_user) { Capistrano::CLI.ui.ask "Enter #{environment} database username:" }
		set(:db_pass) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }

		db_config = ERB.new <<-EOF
		base: &base
		adapter: mysql
		encoding: utf8
		username: #{db_user}
		password: #{db_pass}

		#{environment}:
		database: #{application}_#{environment}
		<<: *base

		test:
		database: #{application}_test
		<<: *base
		EOF

		put db_config.result, "#{shared_path}/config/database.yml"
	end
	after "deploy:setup", "mysql:create_yaml"
	
	
	desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
	after "deploy:finalize_update", "mysql:symlink"
	
	
	# Sets database variables from remote database.yaml
	def prepare_from_yaml
		set(:db_file) { "#{application}-dump.sql.bz2" }
		set(:db_remote_file) { "#{shared_path}/backup/#{db_file}" }
		set(:db_local_file)  { "tmp/#{db_file}" }
		set(:db_user) { db_config[rails_env]["username"] }
		set(:db_pass) { db_config[rails_env]["password"] }
		set(:db_host) { db_config[rails_env]["host"] }
		set(:db_name) { db_config[rails_env]["database"] }
	end
	
	
	def db_config
		@db_config ||= fetch_db_config
	end
	
	
	def fetch_db_config
		require 'yaml'
		file = capture "cat #{shared_path}/config/database.yml"
		db_config = YAML.load(file)
	end
	
end




def prepare_for_db_command
	set :db_name, "#{application}_#{environment}"
	set(:db_admin_user) { Capistrano::CLI.ui.ask "Username with priviledged database access (to create db):" }
	set(:db_user) { Capistrano::CLI.ui.ask "Enter #{environment} database username:" }
	set(:db_pass) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }
end

desc "Populates the database with seed data"
task :seed do
	Capistrano::CLI.ui.say "Populating the database..."
	run "cd #{current_path}; rake RAILS_ENV=#{variables[:rails_env]} db:seed"
end

after "deploy:setup" do
	db.create_yaml if Capistrano::CLI.ui.agree("Create database.yml in app's shared path? [Yn]")
end
























# namespace :mysql do
# 	
# 	desc "Installs Redis via apt-get"
# 	task :install, role: :db do
# 		run "#{sudo} apt-get -y update"
# 		run "#{sudo} apt-get -y install mysql-server"
# 	end
# 	
# 	
# 	desc "Creates database and user"
# 	task :setup, role: :db do
# 		# create datase
# 		mysql -u root -e "create database $1"; 
# 		run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
# 		
# 		run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
# 		# create user + password
# 	end
# 	
# 	
# 	desc "Starts MySQL server"
# 	task :start, role: :db do
# 		# start mysql server
# 	end
# 	
# 	
# 	desc "Stops MySQL server"
# 	task :stop, role: :db do
# 		# stop mysql server
# 	end
# 	
# 	
# end