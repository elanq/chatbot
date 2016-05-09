require 'yaml'
require 'redis'

module App
  # configuration class
  class Config
    attr_reader :token, :message, :redis

    def initialize
      @token = load_config('app/config.yml')
      @redis = Redis.new(host: '127.0.0.1', port: 6379, thread_safe: true)
    end

    private

    def load_config(path)
      YAML.load(IO.read(path))
    end
  end
end
