# ######################
# 
#     Option Prompts
# 
# ######################


##
# Config
##

def generate_ask(question, choices)
  # ask("\r\n\r\n\e[40m\e[32m#{question}\e[0m\r\n\r\n#{choices}\r\n\r\n\e[40m\e[37mChoose:\e[0m")
  ask("\n\n\e[40m\e[32m[?]\e[0m #{question}\e[0m\n#{choices}\n\e[40m\e[37mChoose:\e[0m")
end


# Set platform
# 
puts "\n\e"
if defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby"
  # -JRuby
  @options[:platform] = :jruby
  puts "JRuby detected."._blue
else
  # -MRI [default]
  @options[:platform] = :mri
  puts "MRI Ruby detected."._blue
end



# Database
@options[:db] = generate_ask "Which database would you like to use?", "   (1) PostgreSQL [default]\n   (2) MongoDB"

# App server
if @options[:platform] == :jruby
  @options[:server] = generate_ask "Which application server would you like to use?", "   (1) TorqueBox [default]\n   (2) Puma"
else
  @options[:server] = generate_ask "Which application server would you like to use?", "   (1) Unicorn [default]\n   (2) Puma\n   (3) Thin"
end

# Type of production deployment
@options[:deployment] = generate_ask "How will you be deploying?", "   (1) Capistrano\n   (2) Heroku [default]"




##
# Config Results
##


# Set database
# 
@options[:db] = case @options[:db]
  # -MongoDB
  when "2" then :mongodb
  # -PostgreSQL [default]
  else :postgres
end


# Set app server
# 
if @options[:platform] == :jruby
  @options[:server] = case @options[:server]
    # -Puma
    when "2" then :puma
    # -TorqueBox [default]
    else :torquebox
  end
else
  @options[:server] = case @options[:server]
    # -Puma
    when "2" then :puma
    # -Thin
    when "3" then :thin
    # -Unicorn [default]
    else :unicorn
  end
end



# Set deployment type
# 
@options[:deployment] = case @options[:deployment]
  # -Capistrano
  when "1" then :capistrano
  # -Heroku [default]
  else :heroku
end
