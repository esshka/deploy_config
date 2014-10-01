# Automate deploy process

nginx + rvm + passenger + postgresql + redis + sidekiq

## Setup

Clone this repo to local machine, remove all Capistrano gems from `Gemfile` and run from app's root:

```bash
rake rails:template LOCATION=~/path/to/deploy_setup/deploy_setup.rb
```

It will:

- back up old Capistrano files to `old_cap` dir
- add to `Gemfile` and install Capistrano 3 gems
- create all deploy configs
