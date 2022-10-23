# config valid only for current version of Capistrano
#lock '3.4.0'

set :stages, %w(production staging)
set :default_stage, "staging"
set :application, 'reportbooru'
set :repo_url, 'https://github.com/lunaisnotaboy/reportbooru'
set :user, "danbooru"
set :deploy_to, "/var/www/reportbooru"
set :scm, :git
set :default_env, {
  "PATH" => '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH',
  "RAILS_ENV" => "production"
}
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'public/exports', 'public/user-reports', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')
set :linked_files, fetch(:linked_files, []).push(".env")

Rake::Task["deploy:migrate"].clear_actions
