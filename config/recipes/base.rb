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
	
	%w[start stop restart].each do |command|
		desc "#{command} unicorn server"
		task command, roles: :app, except: {no_release: true} do
			run "/etc/init.d/unicorn_#{application} #{command}"
		end
	end
	
	desc "Symlink mongoid.yml"
	task :symlink_config, roles: :app do
		run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
	end
	after "deploy:finalize_update", "deploy:symlink_config"
	
end
