module Client
  module Banker

    def initialize
        banker_host = ENV['BANKER_HOST']
        connection = Faraday.new(banker_host)
    end

    def upload(file)
    end

    def report(month, year)
      response = connection.get("/banker/report?month=#{month}&year=#{year}")
      JSON.parse(response.body, symbolize_names: true)
    end

    private
    attr_reader :banker_host, :connection
  end
end
