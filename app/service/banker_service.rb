module Service
  class BankerService
    def initialize
      @client = ::Client::Banker.new
    end

    def monthly_summary(month, year)
      results = @client.report(month, year)
      return default_respone if results.empty?
      # somehow this money library will replace 2 last digit into comma
      # So I needed to multiply it first by 100
      text = "saldo awal bulan #{Money.new(results.first.balance* 100, 'IDR').format}"
      text += "\nsaldo akhir bulan #{Money.new(results.last.balance* 100, 'IDR').format}"
      text += "\nTotal pendapatan/pengeluaran bulan ini #{Money.new(results.last.balance* 100 - results.first.balance* 100, 'IDR').format}"
      text
    end

    def default_respone
      'Tidak ada data'
    end

    private
    attr_reader :client
  end
end
