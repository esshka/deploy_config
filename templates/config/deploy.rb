
set :application, '__APP_NAME__'
set :deploy_user, 'deploy'

set :scm, :git
set :repo_url, "git@github.com:username/#{fetch(:application)}.git"

set :format, :pretty

set :rvm_ruby_version, "#{RUBY_VERSION}@#{fetch(:application)}"
set :rvm_type, :user
set :bundle_flags, '--deployment --quiet'
# set :default_env, { rvm_bin_path: '~/.rvm/bin' }

set :linked_files, %w{config/database.yml config/environment_variables.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :keep_releases, 5

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  database.example.yml
  environment_variables.example.yml
  sidekiq.yml
  sidekiq_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
   sidekiq_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
set(:symlinks, [
    {
        source: 'nginx.conf',
        link: "/opt/nginx/conf/sites-enabled/{{full_app_name}}"
    },
    {
      source: "sidekiq_init.sh",
      link: "/etc/init.d/sidekiq_{{full_app_name}}"
    }
])



# Default value for :log_level is :debug
# set :log_level, :debug


namespace :deploy do

  # make sure we're deploying what we think we're deploying
  before :deploy, 'deploy:check_revision'

  # # only allow a deploy with passing tests to deployed
  # before :deploy, "deploy:run_tests"

  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # As of Capistrano 3.1, the `deploy:restart` task is not called automatically.
  after 'deploy:publishing', 'deploy:restart'

end
