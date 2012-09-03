# ######################
# 
#     Option Prompts
# 
# ######################


##
# Config
##

def generate_ask(question, choices)
  ask("\r\n\r\n\e[40m\e[32m#{question}\e[0m\r\n\r\n#{choices}\r\n\r\n\e[40m\e[37mChoose:\e[0m")
end

# Database
@options[:db] = generate_ask "Which database would you like to use?", "(1) PostgreSQL [default]\r\n(2) MongoDB"

# App server
@options[:server] = generate_ask "Which application server would you like to use?", "(1) Unicorn [default]\r\n(2) Puma\r\n(3) Thin"

# Type of production deployment
@options[:deployment] = generate_ask "How will you be deploying?", "(1) Capistrano\r\n(2) Heroku [default]"



## 
# Features
## 

def generate_question(question)
  yes?("\r\n\r\n\e[40m\e[33m#{question}\e[0m\r\n\e[37m[yN]\e[0m")
end

# Authentication?
@options[:auth] = generate_question "Would you like to add authentication? (installs 'sorcery')"

# Admin?
@options[:admin] = generate_question "Will this app have an admin feature? (installs 'inherited_resources')"

# Uploads?
@options[:uploads] = generate_question "Will you be uploading images/attachments to S3? (installs 'aws-sdk' & 'paperclip')"

# Blog?
@options[:blog] = generate_question "Will this app have a blog feature? (installs 'friendly_id')"

# CMS?
@options[:cms] = generate_question "Will this app have a CMS feature? (installs 'ancestry' & 'friendly_id')"

puts "\n\n"



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
@options[:server] = case @options[:server]
  # -Puma
  when "2" then :puma
  # -Thin
  when "3" then :thin
  # -Unicorn [default]
  else :unicorn
end



# Set deployment type
# 
@options[:deployment] = case @options[:deployment]
  # -Capistrano
  when "1" then :capistrano
  # -Heroku [default]
  else :heroku
end