def source_paths
  [File.expand_path("#{File.dirname(__FILE__)}/templates")]
end


# Handling old Capistrano files
if File.file?('Capfile')
  if yes?('Move away old Caps? (yes/no)')
    run 'mkdir old_cap'
    run 'mv Capfile old_cap'
    run 'mv config/deploy.rb old_cap' if File.file?('config/deploy.rb')
    run 'mv config/deploy/ old_cap' if File.directory?('config/deploy/')
  else
    puts 'Boo!'
    return false
  end
end

# Installing Capistrano gems
gem_group :development do
  gem 'capistrano', '~> 3.0', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm', '~> 0.1', require: false
end

bundle_command 'install'
bundle_command 'exec cap install'

# Putting configs where they belong

run 'rm Capfile'
run 'rm config/deploy.rb'
run 'rm config/deploy/production.rb'
run 'rm config/deploy/staging.rb'

copy_file 'Capfile', 'Capfile'

copy_file 'config/deploy.rb', 'config/deploy.rb'
copy_file 'config/deploy/production.rb', 'config/deploy/production.rb'
copy_file 'config/deploy/staging.rb', 'config/deploy/staging.rb'

gsub_file 'config/deploy.rb', '__APP_NAME__', Rails.application.class.parent_name.underscore


copy_file 'config/deploy/shared/database.example.yml.erb', 'config/deploy/shared/database.example.yml.erb'
copy_file 'config/deploy/shared/environment_variables.example.yml.erb', 'config/deploy/shared/environment_variables.example.yml.erb'
copy_file 'config/deploy/shared/nginx.conf.erb', 'config/deploy/shared/nginx.conf.erb'
copy_file 'config/deploy/shared/unicorn.rb.erb', 'config/deploy/shared/unicorn.rb.erb'
copy_file 'config/deploy/shared/unicorn_init.sh.erb', 'config/deploy/shared/unicorn_init.sh.erb'

copy_file 'lib/capistrano/substitute_strings.rb', 'lib/capistrano/substitute_strings.rb'
copy_file 'lib/capistrano/template.rb', 'lib/capistrano/template.rb'

copy_file 'lib/capistrano/tasks/access_check.cap', 'lib/capistrano/tasks/access_check.cap'
copy_file 'lib/capistrano/tasks/check_revision.cap', 'lib/capistrano/tasks/check_revision.cap'
copy_file 'lib/capistrano/tasks/compile_assets_locally.cap', 'lib/capistrano/tasks/compile_assets_locally.cap'
copy_file 'lib/capistrano/tasks/logs.cap', 'lib/capistrano/tasks/logs.cap'
copy_file 'lib/capistrano/tasks/nginx.cap', 'lib/capistrano/tasks/nginx.cap'
copy_file 'lib/capistrano/tasks/restart.cap', 'lib/capistrano/tasks/restart.cap'
copy_file 'lib/capistrano/tasks/setup_config.cap', 'lib/capistrano/tasks/setup_config.cap'

puts 'All done. Have fun.'
puts 'Don\'t forget to fix some settings in:'
puts '  |- config'
puts '      |- deploy'
puts '      |   |- production.rb'
puts '      |   |- staging.rb'
puts '      |- deploy.rb'
