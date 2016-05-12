module App
  module Search
    # Use foursquare api to search user inputted location
    class VenueSearch
      def initialize
        endpoint = YAML.load(IO.read('app/endpoint.yml'))
        @uri = URI(endpoint['foursquare_api'])
      end

      def search(opts = {})
        @keywords = opts[:keywords]
        @uri.query = ''
        @uri.query = URI.encode_www_form opts
        construct_message(JSON.parse(Net::HTTP.get(@uri)))
      end

      private

      def construct_message(response)
        return 'tidak ada hasil' if response['products'].empty?
        response_message = "Hasil pencarian #{@keywords}\n"
        itr = 1
        response['products'].each do |p|
          response_message << "#{itr}. [#{p['name']}](#{p['url']}) \n"
          itr += 1
        end
        response_message << "\n ketik LAGI utk mencari #{@keywords} yang lainnya"
      end
    end
  end
end