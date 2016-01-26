require 'sinatra'
require 'redis'
require 'redis-namespace'

redis_options = {
  host: (ENV['REDIS_HOST'] || 'localhost'),
  port: (ENV['REDIS_PORT'] || 6379),
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
