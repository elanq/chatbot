module App
  # configuration class
  class Config
    attr_reader :token, :redis, :logger

    def initialize
      @token = ENV['TELEGRAM_TOKEN']
      @redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], thread_safe: true)
      @logger = Logger.new(STDOUT)
    end
  end
end
