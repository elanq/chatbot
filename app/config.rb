module Config
  module_function
  @token ||= ENV['TELEGRAM_TOKEN']
  @redis ||= ::Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], thread_safe: true)
  @logger ||= ::Logger.new(STDOUT)

  def redis
    @redis
  end

  def logger
    @logger
  end

  def token
    @token
  end
end
