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
	desc "Export the Procfile to Ubuntu's upstart scripts"
	task :export, :roles => :app do
		run "cd #{release_path} && sudo bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -l #{shared_path}/log"
	end
	desc "Start the application services"
	task :start, :roles => :app do
		sudo "start #{application}"
	end

	desc "Stop the application services"
	task :stop, :roles => :app do
		sudo "stop #{application}"
	end

	desc "Restart the application services"
	task :restart, :roles => :app do
		run "sudo start #{application} || sudo restart #{application}"
	end
end
