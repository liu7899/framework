# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'framework'
set :repo_url, 'git@github.com:liu7899/framework.git'
set :deploy_user, 'ssgene-forum'
set :deploy_to, '/var/www/framework'
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :pty, true


set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache',
                                               'tmp/sockets', 'public/system')


set :linked_files, %w{
 config/database.yml
 config/secrets.yml
 config/settings.yml
}
set :ssh_options, { forward_agent: true, port: 22 }
SSHKit.config.command_map[:rake]  = 'bundle exec rake'
SSHKit.config.command_map[:rails] = 'bundle exec rails'


namespace :deploy do
  desc 'Upload configuration files to server.'
  task :setup do
    on roles(:web) do |host|
      execute :mkdir, "-p #{deploy_to}/shared/config"
      execute :mkdir, "-p #{deploy_to}/shared/tmp/logs #{deploy_to}/shared/tmp/pids #{deploy_to}/shared/tmp/sockets"
      upload! 'config/database.yml', "#{deploy_to}/shared/config/database.yml"
      upload! 'config/secrets.yml', "#{deploy_to}/shared/config/secrets.yml"
      upload! 'config/settings.yml', "#{deploy_to}/shared/config/settings.yml"
    end
  end

  desc 'Create database if not exist.'
  task :create do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:create'
        end
      end
    end
  end
  desc 'Runs rake db:migrate on all app server'
  desc '12234'*123
  task :migrate_all => [:set_rails_env] do
      on roles(:app), in: :parallel do
          within release_path do
              with rails_env: fetch(:rails_env) do
                  execute :rake, "db:migrate"
              end
          end
      end
  end
end
