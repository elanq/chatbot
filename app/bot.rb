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
      @request_location = false
      @logger = config.logger
    end

    # is bot requesting location? return true if it is
    def request_location?
      @logger.info "location request status : #{@request_location}"
      @request_location
    end

    # processing query.
    def process(input)
      # reset params
      @logger.info 'reset search parameters'
      @message = nil
      message_text = input.text
      @user_reply_id = input.chat.id
      @request_location = false

      case message_text
      when /caribarang/i
        # just in case
        @request_location = false
        search_term = {
          keywords: message_text,
          current_page: 0,
          last_request_at: Time.now
        }
        save_search_term(search_term)
        search_product
      when /carilokasi/i
        search_term = {
          venue_keywords: message_text,
          last_request_at: Time.now
        }
        save_search_term(search_term)
        @request_location = true
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
      "Halo! saya adalah EQBot, saya bisa membantu kamu untuk mencari barang yang kamu butuhkan di bukalapak.com \n Silahkan CARI nama barang yang kamu inginkan, nanti saya carikan barangnya ya :D"
    end

    # set search param to redis
    def save_search_term(search_term)
      search_term.each do |k, v|
        @redis.hset "chat-#{@user_reply_id}", k, v
      end
    end

    # filter query and search!
    def do_search(search_more = false)
      # keywords = @redis.hget "chat-#{@user_reply_id}", 'keywords'
      case search_context keywords
      when 'product'
        search_product search_more
      when 'location'
        @request_location = true
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
    end

    # search venue
    def search_venue(lat, long)
      query = @redis.hget "chat-#{@user_reply_id}", 'venue_keywords'
      query.slice! query.split[0]

      @logger.info "search venue with query'#{query}'"

      opts = { query: query, limit: 6, ll: "#{lat},#{long}" }
      @message = query.nil? ? 'Terjadi kesalahan dalam pencarian' : @venue_search.search(opts)
      @logger.info "search venue completed, return message '#{@message}'"
    end
  end
end
