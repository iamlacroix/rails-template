namespace :redis do
	
	desc "Installs Redis via apt-get"
	task :install, role: :app do
		# run "rake redis:install dtach:install"
		# run "#{sudo} apt-get -y update"
		run "#{sudo} apt-get -y install redis-server"
	end
	after "deploy:install", "redis:install"
	
	
	desc "Creates Upstart file"
	task :setup, role: :app do
		# create upstart file if necessary
	end
	
	
end