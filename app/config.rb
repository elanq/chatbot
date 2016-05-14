require 'yaml'
require 'redis'
require 'logger'

module App
  # configuration class
  class Config
    attr_reader :token, :message, :redis, :keys, :logger

    def initialize
      @token = load_config('app/config.yml')
      @keys = load_config('app/keywords.yml')
      @redis = Redis.new(host: '127.0.0.1', port: 6379, thread_safe: true)
      @logger = Logger.new(STDOUT)
    end

    def tele_token
      @token['token']
    end

    private

    def load_config(path)
      YAML.load(IO.read(path))
    end
  end
end
