require 'yaml'

module App
  # configuration class
  class Config
    attr_reader :token

    def initialize
      @token = YAML.load(IO.read('app/config.yml'))['token']
    end

  end
end
