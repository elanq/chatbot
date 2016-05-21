require_relative '../app/search/product_search.rb'
require_relative '../app/search/venue_search.rb'
require 'token'
require 'json'

module App
  # robot logic
  class Bot
    # initialize bot
    def initialize(config)
      @product_search = App::Search::ProductSearch.new
      @venue_search = App::Search::VenueSearch.new
      @redis = config.redis
      @logger = config.logger
    end

    # is bot requesting location? return true if it is
    def request_location?(reply_id)
      request_location = @redis.hget "chat-#{reply_id}", 'request_location'
      @logger.info "location request status : #{request_location}"
      request_location.nil? ? false : true
    end

    # processing query.
    def process(input)
      # reset params
      @logger.info 'reset search parameters'
      @message = nil
      message_text = input.text
      @user_reply_id = input.chat.id

      case message_text
      when /caribarang/i
        search_term = {
          keywords: message_text,
          current_page: 0,
          last_request_at: Time.now,
          request_location: false
        }
        save_search_term(search_term)
        search_product
      when /carilokasi/i
        search_term = {
          venue_keywords: message_text,
          last_request_at: Time.now,
          request_location: true
        }
        save_search_term(search_term)
        @message = 'Bisa minta lokasi sekarang?'
      when /BANTU/i, /TOLONG/i, /APA/i
        @message = help_message
      when /LAGI/i
        search_product true
      when /TEST/i, /PING/i
        @message = 'Saya online gan! apa yang bisa saya BANTU? :D'
      end
    end

    # handlng message with location
    def handle_location(lat, lng)
      @logger.info "handle location with lat #{lat} and lng #{lng}"
      search_venue lat, lng
    end

    # get bot reply message
    def reply
      @message ||= 'Maaf, perintah anda tidak saya ketahui. ketik BANTUAN untuk melihat daftar perintah saya!'
    end

    private

    # help message
    def help_message
      "/caribarang <nama barang> untuk mencari barang yang tersedia di bukalapak.com\n /carilokasi untuk mencari lokasi di sekitar kamu"
    end

    # set search param to redis
    def save_search_term(search_term)
      search_term.each do |k, v|
        @redis.hset "chat-#{@user_reply_id}", k, v
      end
    end

    # search product
    def search_product(search_more = false)
      keywords = @redis.hget "chat-#{@user_reply_id}", 'keywords'
      page = @redis.hget "chat-#{@user_reply_id}", 'current_page'
      page = @redis.hincrby "chat-#{@user}", 'current_page', 1 if search_more

      keywords.slice! keywords.split[0]
      opts = { keywords: keywords.strip!, per_page: 6, page: page }

      @message = keywords.nil? ? 'Terjadi kesalahan dalam pencarian' : @product_search.search(opts)
      save_search_term(request_location: false)
    end

    # search venue
    def search_venue(lat, long)
      query = @redis.hget "chat-#{@user_reply_id}", 'venue_keywords'
      query.slice! query.split[0]

      @logger.info "search venue with query'#{query}'"
      ll = "#{lat},#{long}"
      opts = { query: query, limit: 6, ll: ll }
      @venue_search.origin_location = ll
      @message = query.nil? ? 'Terjadi kesalahan dalam pencarian' : @venue_search.search(opts)
      @logger.info "search venue completed, return message '#{@message}'"
      # change request status back to false
      save_search_term(request_location: false, last_location: ll)
    end
  end
end
