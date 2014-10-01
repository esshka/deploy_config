set :stage, :production
set :rails_env, :production
set :branch, :master

# if multiple stages are side by side on the server
# "#{fetch(:application)}_#{fetch(:stage)}"
set :full_app_name, "#{fetch(:application)}"
set :server_name, '__APP_PRODUCTION_DOMAIN__'

server '__PRODUCTION_SERVER_IP_OR_SSH_ALIAS__',
       user: fetch(:deploy_user),
       roles: %w{web app db},
       primary: true,
       ssh_options: {
           forward_agent: true
       }

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

set :enable_ssl, false
