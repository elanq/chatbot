module Crawler
    # crawl tiket.com ticketing website
    class Tiket
      def initialize
        @message = 'Pencarian tidak valid'
        @tiket_site = ENV['TIKET_WEB']
        @spider = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
      end

      def crawl(input)

      end

      def result
      end

    end
  end


