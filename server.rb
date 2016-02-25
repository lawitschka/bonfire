require 'sinatra'
require 'redis'
require 'redis-namespace'

configure do
  set :server, :puma
  set :bind, '0.0.0.0'
  set :port, 80
end

redis_options = {
  host: (ENV['REDIS_DB_HOST'] || ENV['REDIS_PORT_6379_TCP_ADDR']),
  port: (ENV['REDIS_DB_PORT'] || ENV['REDIS_PORT_6379_TCP_PORT']),
  password: (ENV['REDIS_PASSWORD'] || nil)
}
redis_connection = Redis.new(redis_options)

get '/' do
  404
end

get '/:project' do |project|
  content_type 'text/html'

  redis = Redis::Namespace.new(project.to_sym, redis: redis_connection)
  index_key = params[:index_key] || redis.get('index:current')
  index = redis.get("index:#{index_key}")

  index ? index : 404
end
