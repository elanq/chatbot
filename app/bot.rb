require_relative '../app/product_search.rb'

module App
  # robot logic
  class Bot
    def initialize(redis)
      @product_search = App::ProductSearch.new
      @redis = redis
    end

    def process(input)
      @message = nil
      case input
      when /CARI/i
        # should I specified it by user id?
        input.slice! input.split(' ')[0]
        opts = { keywords: input.strip!, per_page: 10 }
        @message = @product_search.search opts
      when /BANTUAN/i, /TOLONG/i, /APA/i
        @message = 'CARI <kata kunci> : mencari barang berdasarkan kata kunci\n'
      when /BUSUK/i, /BEGO/i, /TOLOL/i, /ANJING/i, /ASU/i
        @message = 'Omongannya dijaga bro ;)'
      when /LAGI/i
        # TODO : save page to redis server
      end
    end

    def reply
      @message ||= 'Maaf, perintah anda tidak saya ketahui. ketik BANTUAN untuk melihat daftar perintah saya!'
    end
  end
end
