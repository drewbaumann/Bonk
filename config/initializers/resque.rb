redis_url = ENV['REDISTOGO_URL'] || "redis://localhost:6379"
uri = URI.parse(redis_url)
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.redis = REDIS
Resque.inline = Rails.env.test?
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }