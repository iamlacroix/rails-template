# # require File.expand_path(File.dirname(__FILE__) + '/../utilities')
# # require File.expand_path(File.dirname(__FILE__) + '/manage')
# 
# # set :mongodb_data_path, "/data/db"
# # set :mongodb_bin_path, "/opt/mongo"
# 
# namespace :mongodb do    
# 	desc "Installs mongodb via apt repository"
# 	task :install, :role => :app do
# 		run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
# 		run "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen"
# 		run "#{sudo} apt-get -y update"
# 		run "#{sudo} apt-get -y install mongodb-10gen"
# 		
# 		# utilities.apt_install "tcsh scons g++ libpcre++-dev"
# 		# utilities.apt_install "libboost1.37-dev libreadline-dev xulrunner-dev"
# 		# mongodb.make_spidermonkey
# 		# mongodb.make_mongodb
# 		
# 		# mongodb.setup_db_path
# 	end
# 	after "deploy:install", "mongodb:install"
# 
# 	# task :make_spidermonkey, :role => :app do
# 	# 	run "mkdir -p ~/tmp"
# 	# 	run "cd ~/tmp; wget ftp://ftp.mozilla.org/pub/mozilla.org/js/js-1.7.0.tar.gz"
# 	# 	run "cd ~/tmp; tar -zxvf js-1.7.0.tar.gz"
# 	# 	run "cd ~/tmp/js/src; export CFLAGS=\"-DJS_C_STRINGS_ARE_UTF8\""
# 	# 	run "cd ~/tmp/js/src; #{sudo} make -f Makefile.ref"
# 	# 	run "cd ~/tmp/js/src; #{sudo} JS_DIST=/usr make -f Makefile.ref export"
# 	# end
# 	# 
# 	# task :make_mongodb, :role => :app do
# 	# 	sudo "rm -rf ~/tmp/mongo"
# 	# 	run "cd ~/tmp; git clone git://github.com/mongodb/mongo.git"
# 	# 	run "cd ~/tmp/mongo; #{sudo} scons all"
# 	# 	run "cd ~/tmp/mongo; #{sudo} scons --prefix=#{mongodb_bin_path} install"
# 	# end
# 
# 	# task :setup_db_path, :role => :app do
# 	# 	sudo "mkdir -p #{mongodb_data_path}"
# 	# 	mongodb.start
# 	# end
# 
# end
