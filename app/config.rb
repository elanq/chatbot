require 'redis'
require 'logger'
require 'dotenv'

module App
  # configuration class
  class Config
    attr_reader :token, :redis, :logger

    def initialize
      Dotenv.load
      @token = ENV['TELEGRAM_TOKEN']
      @redis = Redis.new(host: '127.0.0.1', port: 6379, thread_safe: true)
      @logger = Logger.new(STDOUT)
    end

  end
end
