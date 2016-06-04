require 'redis'
require 'logger'


module App
  # configuration class
  class Config
    attr_reader :token, :message, :redis, :keys, :logger

    def initialize
      @token = ENV['TELEGRAM_TOKEN']
      @redis = Redis.new(host: '127.0.0.1', port: 6379, thread_safe: true)
      @logger = Logger.new(STDOUT)
    end

    def tele_token
      @token['token']
    end

  end
end
