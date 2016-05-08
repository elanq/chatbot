require_relative '../app/product_search.rb'

module App
  # robot logic
  class Bot

    def initialize
      @product_search = App::ProductSearch.new
    end

    def process(input)
      case input
      when /cari/i

      end
    end

    def reply

    end
  end
end
