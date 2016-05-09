require_relative '../app/product_search.rb'

module App
  # robot logic
  class Bot
    def initialize(redis)
      @product_search = App::ProductSearch.new
      @redis = redis
    end

    def process(input)
      case input
      when /CARI/
        # should I specified it by user id?
        input.slice! 'CARI '
        opts = { keywords: input, per_page: 10 }
        @message = @product_search.search opts
      end
    end

    def reply
      @message ||= 'Maaf, perintah anda tidak saya ketahui. ketik BANTUAN untuk melihat daftar perintah saya!'
    end
  end
end
