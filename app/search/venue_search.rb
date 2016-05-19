module App
  module Search
    # Use foursquare api to search user inputted location
    class VenueSearch
      require 'foursquare2'

      attr_writer :origin_location

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

      def search_recommended(opts = {})
        return 'Tidak bisa mencari data, mungkin locationnya dinyalain?' if opts[:ll].nil?
      end

      private

      def construct_message(response)
        url = 'https://www.google.com/maps/dir/'
        message = "Rekomendasi tempat sekitar kamu\n"
        response['venues'].each do |v|
          ll_to = "#{v['location']['lat']},#{v['location']['lng']}"
          @origin_location ||= '-6.2739129,106.8216103'
          route_link = "#{url}#{@origin_location}/#{ll_to}"
          message << "[#{v['name']} - #{v['location']['address']}](#{route_link}))\n" unless v['location']['address'].nil?
        end
        message
      end

      def construct_keyboard_message(response)
      end
    end
  end
end