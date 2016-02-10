schedule_file = "config/schedule.yml"

if File.exists?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

# three unicorns = 3 connections
Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

# so one sidekiq can have 5 connections
Sidekiq.configure_server do |config|
  config.redis = { :size => 5 }
end
