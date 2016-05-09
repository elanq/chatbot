require 'yaml'

module App
  # configuration class
  class Config
    attr_reader :token, :message

    def initialize
      @token = load_config('app/config.yml')
    end

    private

    def load_config(path)
      YAML.load(IO.read(path))
    end
  end
end
