# System Ruby -- Available via sudo for Foreman

set_default :yaml_version, "yaml-0.1.4"
set_default :ruby_system_version, "1.9.3-p194"
set_default :ruby_system_url, "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-#{ruby_system_version}.tar.gz"
set_default :rubygems_version, "rubygems-1.8.24"
set_default :rubygems_url, "http://rubyforge.org/frs/download.php/76073/#{rubygems_version}.tgz"


namespace :ruby do
	
	desc "Install libyamlfor sudo user (needed for Foreman)"
	task :install_libyaml, roles: :app do
		run "mkdir -p ~/.data"
		run "cd ~/.data"
		run "wget http://pyyaml.org/download/libyaml/#{yaml_version}.tar.gz"
		run "tar xzvf #{yaml_version}.gz"
		run "rm #{yaml_version}.tar.gz"
		run "cd #{yaml_version}"
		run "./configure --prefix=/usr/local"
		run "make"
		run "#{sudo} make install"
	end
	after "deploy:install", "ruby:install_libyaml"
	
	
	desc "Install Ruby for sudo user (needed for Foreman)"
	task :install_ruby, roles: :app do
		run "mkdir -p ~/.data"
		run "cd ~/.data"
		run "wget #{ruby_system_url}"
		run "tar xzvf ruby-#{ruby_system_version}.tar.gz"
		run "rm ruby-#{ruby_system_version}.tar.gz"
		run "cd ruby-#{ruby_system_version}"
		run "./configure --prefix=/usr/local --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib"
		run "make"
		run "#{sudo} make install"
	end
	after "deploy:install", "ruby:install_ruby"
	
	
	desc "Install Rubygems, and the Bundler gem for sudo user (needed for Foreman)"
	task :install_rubygems, roles: :app do
		# Rubygems
		run "mkdir -p ~/.data"
		run "cd ~/.data"
		run "wget #{rubygems_url}"
		run "tar xzvf #{rubygems_url}"
		run "rm #{rubygems_version}.tgz"
		run "cd #{rubygems_version}"
		run "#{sudo} ruby setup.rb"
		# Bundler
		run "sudo gem install bundler --no-rdoc --no-ri"
	end
	after "deploy:install", "ruby:install_rubygems"
	
end





# # YAML (psych)
# wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
# tar xzvf yaml-0.1.4.tar.gz
# cd yaml-0.1.4
# ./configure --prefix=/usr/local
# make
# sudo make install
# 
# 
# # Ruby
# wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz
# tar xzvf ruby-1.9.3-p0.tar.gz
# cd ruby-1.9.3-p0
# ./configure --prefix=/usr/local --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib
# make
# sudo make install
# 
# 
# # Ruby Notes
# ---------------
# # Thanks for the useful tip.  I found that instead of
#     —with-opt-dir=/usr/local/lib
# # I need to run ./configure with
#     —with-opt-dir=/usr/local
# # (without the lib).  Otherwise, strace shows the loader trying to load the libyaml library from /usr/local/lib/lib.






