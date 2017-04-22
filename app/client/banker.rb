module Client
  class Banker

    def initialize
        @banker_host = ENV['BANKER_HOST']
        @connection = Faraday.new(banker_host)
    end

    def upload(file)
    end

    def report(month, year)
      response = @connection.get("/banker/report?month=#{month}&year=#{year}")
      return [] if response.status == 404
      raw = JSON.parse(response.body, symbolize_names: true)
      generate_model(raw)
    end

    private
    attr_reader :banker_host, :connection

    def generate_model(data)
      data.map do |val|
        ::Model::BankRecord.new(val)
      end
    end
  end
end
