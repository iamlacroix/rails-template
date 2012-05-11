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
after 'deploy:update', 'foreman:export'
after 'deploy:update', 'foreman:restart'

namespace :foreman do
	
	desc "Skip password for sudo foreman tasks"
	task :foreman_sudoers do
		# run "#{sudo} ls"
		# run "#{sudo} echo Cmnd_Alias FOREMAN = /usr/local/bin/bundle exec foreman export upstart /etc/init*, /sbin/start #{application}, /sbin/stop #{application}, /sbin/restart #{application} >> /etc/sudoers.d/foreman"
		# run "#{sudo} echo 'admin ALL=(ALL) NOPASSWD: FOREMAN'  >> /etc/sudoers.d/foreman"
		template "foreman.erb", "~/foreman_sudoers"
		# template "foreman.erb", "/tmp/foreman"
		# run "#{sudo} mv /tmp/foreman /etc/sudoers.d/"
		# run "#{sudo} chmod 0440 /etc/sudoers.d/foreman"
		# run "#{sudo} chown root:root /etc/sudoers.d/foreman"
	end
	after "deploy:setup", "foreman:foreman_sudoers"
	
	
	desc "Export the Procfile to Ubuntu's upstart scripts"
	task :export, :roles => :app do
		run "cd #{release_path} && sudo -l bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -l #{shared_path}/log"
	end
	
	
	desc "Start the application services"
	task :start, :roles => :app do
		sudo "sudo -l start #{application}"
	end
	
	
	desc "Stop the application services"
	task :stop, :roles => :app do
		sudo "sudo -l stop #{application}"
	end
	
	
	desc "Restart the application services"
	task :restart, :roles => :app do
		run "sudo -l start #{application} || sudo -l restart #{application}"
	end
	
end
