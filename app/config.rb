module Config
  module_function
  @token ||= ENV['TELEGRAM_TOKEN']
  @redis ||= ::Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], thread_safe: true)
  @logger ||= ::Logger.new(STDOUT)
  @banker_client ||= ::Client::Banker.new

  def redis
    @redis
  end

  def logger
    @logger
  end

  def token
    @token
  end

  def banker_client
    @banker_client
  end
end
