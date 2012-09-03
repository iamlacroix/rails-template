def template(from, to)
	erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
	put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
	set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
	
	desc "Install everything onto the server"
	task :install do
		run "#{sudo} apt-get -y update"
		run "#{sudo} apt-get -y install python-software-properties"
	end
	
	
	namespace :assets do
		task :precompile, :roles => :web, :except => { :no_release => true } do
			from = source.next_revision(current_revision)
			if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
				run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
			else
				logger.info "Skipping asset pre-compilation because there were no asset changes"
			end
		end
	end
	
	
	# Use Foreman instead
	# ==========
	# %w[start stop restart].each do |command|
	# 	desc "#{command} unicorn server"
	# 	task command, roles: :app, except: {no_release: true} do
	# 		run "/etc/init.d/unicorn_#{application} #{command}"
	# 	end
	# end
	
end




# Foreman
# =======
after 'deploy:start', 'foreman:export'
after 'deploy:start', 'foreman:start'
after 'deploy:restart', 'foreman:export'
after 'deploy:restart', 'foreman:restart'

namespace :foreman do
	
	desc "Skip password for sudo foreman tasks"
	task :foreman_sudoers do
		template "foreman.erb", "/home/#{user}/foreman_sudoers"
		run "#{sudo} chgrp admin /etc/init/"
		run "#{sudo} chmod 775 /etc/init/"
	end
	after "deploy:setup", "foreman:foreman_sudoers"
	
	
	desc "Export the Procfile to Ubuntu's upstart scripts"
	task :export, :roles => :app do
		run "cd #{release_path} && bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -l #{shared_path}/log"
	end
	
	
	desc "Start the application services"
	task :start, :roles => :app do
		run "sudo start #{application}"
	end
	
	
	desc "Stop the application services"
	task :stop, :roles => :app do
		run "sudo stop #{application}"
	end
	
	
	desc "Restart the application services"
	task :restart, :roles => :app do
		run "sudo restart #{application}"
	end
	
end