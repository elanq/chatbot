module App
  module Service
    # Use foursquare api to search user inputted location
    class VenueSearch
      require 'foursquare2'

      attr_writer :origin_location

      def initialize
        api_version = Time.now.strftime('%Y%m%d')
        client_id = ENV['FOURSQUARE_CLIENT_ID']
        client_secret = ENV['FOURSQUARE_CLIENT_SECRET']
        @foursquare_client = Foursquare2::Client.new(client_id: client_id, client_secret: client_secret, api_version: api_version)
      end

      def search(opts = {})
        return 'Tidak bisa mencari data' if opts[:query].nil? || opts[:ll].nil?
        construct_message(@foursquare_client.search_venues(opts).to_hash)
      end

      def search_recommended(opts = {})
        return 'Tidak bisa mencari data, mungkin locationnya belom dinyalain?' if opts[:ll].nil?
      end

      private

      def construct_message(response)
        url = 'https://www.google.com/maps/dir/'
        venues = response['venues']
        message = venues.empty? ? "Tidak menemukan lokasi yang kamu maksud :(\n" : "Rekomendasi tempat sekitar kamu\n"
        venues.each do |v|
          ll_to = "#{v['location']['lat']},#{v['location']['lng']}"
          @origin_location ||= '-6.2739129,106.8216103'
          route_link = "#{url}#{@origin_location}/#{ll_to}"
          message << "[#{v['name']} #{'-' unless v['location']['address'].nil?} #{v['location']['address']}](#{route_link})\n"
        end
        message
      end

      def construct_keyboard_message(response)
      end
    end
  end
end
