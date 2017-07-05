module Client
  class Banker
    YEARLY_REPORT = "yearly"
    MONTHLY_REPORT = "monthly"

    def initialize
        @banker_host = ENV['BANKER_HOST']
        @connection = Faraday.new(banker_host)
        @multipart_connection = Faraday.new(banker_host) do |conn|
          conn.request :multipart
          conn.request :url_encoded
          conn.adapter :net_http
        end
    end

    def summary(month, year)
      endpoint = MONTHLY_REPORT
      endpoint = YEARLY_REPORT if month == "00"

      response = @connection.get("/banker/report/#{endpoint}?month=#{month}&year=#{year}&type=summary")
      return {} if response.status != 200
      raw = JSON.parse(response.body)
      ::Model::BankSummary.new(raw)
    end

    def report(month, year)
      response = @connection.get("/banker/report?month=#{month}&year=#{year}")
      return [] if response.status == 404
      raw = JSON.parse(response.body, symbolize_names: true)
      generate_model(raw)
    end

    private
    attr_reader :banker_host, :connection, :multipart_connection

    def generate_model(data)
      data.map do |val|
        ::Model::BankRecord.new(val)
      end
    end
  end
end
