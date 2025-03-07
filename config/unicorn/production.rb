# Set your full path to application.
app_path = "/var/www/reportbooru/current"

# Set unicorn options
worker_processes 24

preload_app false
timeout 180
listen "127.0.0.1:9000"

# Spawn unicorn master worker for user apps (group: apps)
user 'danbooru', 'danbooru'

# Fill path to your app
working_directory app_path

# Should be 'production' by default, otherwise use other env 
ENV['RAILS_ENV'] = 'production'

# Log everything to one file
stderr_path "/dev/null"
stdout_path "/dev/null"

# Set master PID location
pid "/var/www/reportbooru/shared/pids/unicorn.pid"

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
