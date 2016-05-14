module App
  module Search
    # Use foursquare api to search user inputted location
    class VenueSearch
      require 'foursquare2'

      def initialize
        token = YAML.load(IO.read('app/config.yml'))
        api_version = Time.now.strftime('%Y%m%d')
        client_id = token['foursquare']['client_id']
        client_secret = token['foursquare']['client_secret']
        @foursquare_client = Foursquare2::Client.new(client_id: client_id, client_secret: client_secret, api_version: api_version)
      end

      def search(opts = {})
        return 'Tidak bisa mencari data' if opts[:query].nil? || opts[:ll].nil?
        construct_message(@foursquare_client.search_venues(opts).to_hash)
      end

      private

      def construct_message(response)
        message = "Tempat oke deket sini\n"
        response['venues'].each do |v|
          message << "#{v['name']} - #{v['location']['address']})\n" unless v['location']['address'].nil?
        end
        message
      end
    end
  end
end