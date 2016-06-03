module App
  module Search
    # used to search product with BL Api and provide the result in message
    class ProductSearch
      def initialize
        endpoint = YAML.load(IO.read('app/endpoint.yml'))
        @uri = URI(endpoint['bukalapak_api']['product_search'])
      end

      def search(opts = {})
        @keyword = opts[:keywords]
        @uri.query = ''
        @uri.query = URI.encode_www_form opts
        construct_message(JSON.parse(Net::HTTP.get(@uri)))
      end

      private

      def construct_message(response)
        return 'tidak ada hasil' if response['products'].empty?
        response_message = "Hasil pencarian #{@keyword}\n"
        itr = 1
        response['products'].each do |p|
          response_message << "#{itr}. [#{p['name']}](#{p['url']}) \n"
          itr += 1
        end
        response_message << "\n ketik LAGI utk mencari #{@keyword} yang lainnya"
      end
    end
  end
end
