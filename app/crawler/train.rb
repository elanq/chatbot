module App
  module Crawler
    class Train
      def inititalize
        @spiderman = Mechanize.new do |agent|
          agent.user_agent_alias = 'Mac Safari'
        end
        @train_site = ENV['KERETA_API_WEB']
      end

      def scrap
      end

      def result
      end
    end
  end
end
