require 'erb'

set_default(:mysql_host, "localhost")
set_default(:mysql_user) { application }
set_default(:mysql_password) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }
set_default(:mysql_database) { "#{application}_production" }


namespace :mysql do
	
	desc <<-EOF
	Performs a compressed database dump. \
	WARNING: This locks your tables for the duration of the mysqldump.
	Don't run it madly!
	EOF
	task :dump, :roles => :db, :only => { :primary => true } do
		prepare_from_yaml
		run "mysqldump --user=#{mysql_user} -p --host=#{mysql_host} #{mysql_database} | bzip2 -z9 > #{db_remote_file}" do |ch, stream, out|
			ch.send_data "#{mysql_password}\n" if out =~ /^Enter password:/
			puts out
		end
	end
	
	
	desc "Restores the database from the latest compressed dump"
	task :restore, :roles => :db, :only => { :primary => true } do
		prepare_from_yaml
		run "bzcat #{db_remote_file} | mysql --user=#{mysql_user} -p --host=#{mysql_host} #{mysql_database}" do |ch, stream, out|
			ch.send_data "#{mysql_password}\n" if out =~ /^Enter password:/
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
		# run "#{sudo} apt-get -y update"
		run "#{sudo} apt-get -y install mysql-server"
	end
	# after "deploy:install", "mysql:install"
	
	
	desc "Create MySQL database and user for this environment using prompted values"
	task :setup, :roles => :db, :only => { :primary => true } do
		prepare_for_db_command

		sql = <<-SQL
		CREATE DATABASE #{mysql_database};
		GRANT ALL PRIVILEGES ON #{mysql_database}.* TO #{mysql_user}@localhost IDENTIFIED BY '#{mysql_password}';
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
		# Original 'set' -----
		# set(:mysql_user) { Capistrano::CLI.ui.ask "Enter #{environment} database username:" }
		# set(:mysql_password) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }
		# Custom 'set' -----
		# set_default(:postgresql_user) { application }
		# set_default(:mysql_password) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }
		
		template "mysql.yml.erb", "#{shared_path}/config/database.yml"
		# TODO move this into ERB template, it's broken
		# db_config = ERB.new <<-EOF
		# base: &base
		# adapter: mysql2
		# encoding: utf8
		# username: #{mysql_user}
		# password: #{mysql_password}
		# 
		# #{environment}:
		# database: #{application}_#{environment}
		# <<: *base
		# 
		# test:
		# database: #{application}_test
		# <<: *base
		# EOF

		# put db_config.result, "#{shared_path}/config/database.yml"
	end
	after "deploy:setup", "mysql:create_yaml"
	
	
	desc "Symlink the database.yml file into latest release"
	task :symlink, roles: :app do
		run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	end
	before "deploy:assets:precompile", "mysql:symlink"
	after "deploy", "mysql:symlink"
	
	
	# Sets database variables from remote database.yaml
	def prepare_from_yaml
		set(:db_file) { "#{application}-dump.sql.bz2" }
		set(:db_remote_file) { "#{shared_path}/backup/#{db_file}" }
		set(:db_local_file)  { "tmp/#{db_file}" }
		set(:mysql_user) { db_config[rails_env]["username"] }
		set(:mysql_password) { db_config[rails_env]["password"] }
		set(:mysql_host) { db_config[rails_env]["host"] }
		set(:mysql_database) { db_config[rails_env]["database"] }
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
	# set :mysql_database, "#{application}_#{environment}"
	set(:db_admin_user) { Capistrano::CLI.ui.ask "Username with priviledged database access (to create db):" }
	# set(:mysql_user) { Capistrano::CLI.ui.ask "Enter #{environment} database username:" }
	# set(:mysql_password) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }
end

desc "Populates the database with seed data"
task :seed do
	Capistrano::CLI.ui.say "Populating the database..."
	run "cd #{current_path}; rake RAILS_ENV=#{variables[:rails_env]} db:seed"
end

# after "deploy:setup" do
# 	db.create_yaml if Capistrano::CLI.ui.agree("Create database.yml in app's shared path? [Yn]")
# end