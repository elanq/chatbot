module Service
  class BankerService
    def initialize
      @client = ::Client::Banker.new
    end

    def upload_monthly_mutation(file, year)
      return "invalid file" if file.nil?
      opt = {}
      opt[:year] = year if year
      @client.report(file, opt)

      text = "berhasil upload barang"
      text
    end

    def summary(month, year)
      result = @client.summary(month, year)
      return default_response unless result.class == Model::BankSummary

      text = "Total pendapatan : #{Money.new(result.total_income* 100, 'IDR').format}"
      text += "\nTotal pengeluaran : #{Money.new(result.total_outcome* 100, 'IDR').format}"
      text += "\nSaldo: #{Money.new(result.current_balance* 100, 'IDR').format}"
      text += "\nProfit: #{Money.new(result.profit* 100, 'IDR').format}"
      text 
    end

    def monthly_summary(month, year)
      results = @client.report(month, year)
      return default_response if results.empty?
      # somehow this money library will replace 2 last digit into comma
      # So I needed to multiply it first by 100
      text = "saldo awal bulan #{Money.new(results.first.balance* 100, 'IDR').format}"
      text += "\nsaldo akhir bulan #{Money.new(results.last.balance* 100, 'IDR').format}"
      text += "\nTotal pendapatan/pengeluaran bulan ini #{Money.new(results.last.balance* 100 - results.first.balance* 100, 'IDR').format}"
      text
    end

    def default_response
      'Tidak ada data'
    end

    private
    attr_reader :client
  end
end
