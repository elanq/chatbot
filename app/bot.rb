require_relative '../app/search/product_search.rb'
require_relative '../app/search/venue_search.rb'
require 'token'
require 'json'

module App
  # robot logic
  class Bot
    def initialize(config)
      @product_search = App::Search::ProductSearch.new
      @venue_search = App::Search::VenueSearch.new
      @redis = config.redis
      @context_keys = config.keys['context']
      @request_location = false
    end

    def request_location?
      @request_location
    end

    def process(input)
      # reset params
      @message = nil
      message_text = input.text
      @user_reply_id = input.chat.id
      @request_location = false

      case message_text
      when /BANTU/i, /TOLONG/i, /APA/i
        @message = help_message
      when /LAGI/i
        do_search true
      when /TEST/i, /PING/i
        @message = 'Saya online gan! apa yang bisa saya BANTU? :D'
      when *filter_swearing
        @message = 'Omongannya dijaga bro ;)'
      when *filter_search_product
        search_term = {
          keywords: message_text,
          current_page: 0,
          last_request_at: Time.now,
          search_context: search_context(message_text)
        }
        save_search_term(search_term)
        do_search
      end
    end

    def handle_callback(message)
      case message.data
        when 'confirm_location'
          message_location = message.message.location
          search_venue message_location.latitude, message_location.longitude
      end
    end

    def reply
      @message ||= 'Maaf, perintah anda tidak saya ketahui. ketik BANTUAN untuk melihat daftar perintah saya!'
    end

    private

    def help_message
      "Halo! saya adalah EQBot, saya bisa membantu kamu untuk mencari barang yang kamu butuhkan di bukalapak.com \n Silahkan CARI nama barang yang kamu inginkan, nanti saya carikan barangnya ya :D"
    end

    def save_search_term(search_term)
      search_term.each do |k, v|
        @redis.hset "chat-#{@user_reply_id}", k, v
      end
    end

    def do_search(search_more = false)
      keywords = @redis.hget "chat-#{@user_reply_id}", 'keywords'
      case search_context keywords
      when 'product'
        search_product search_more
      when 'location'
        @request_location = true
      end
    end

    def search_product(search_more = false)
      keywords = @redis.hget "chat-#{@user_reply_id}", 'keywords'
      page = @redis.hget "chat-#{@user_reply_id}", 'current_page'
      page = @redis.hincrby "chat-#{@user}", 'current_page', 1 if search_more

      keywords.slice! keywords.split[0]
      opts = { keywords: keywords.strip!, per_page: 6, page: page }

      @message = @product_search.search opts
    end

    def search_venue(lat, long)
      query = @redis.hget "chat-#{@user_reply_id}", 'keywords'
      keywords = filter_search_product.concat filter_search_venue
      keywords.each do |v|
        query.slice! v
      end

      opts = {query: query, limit: 6, ll: "#{lat},#{long}"}
      @message = @venue_search.search opts
    end

    def search_context(keywords)
      context = 'product'
      case keywords
      when *filter_search_venue
        context = 'location'
      end
      context
    end

    def filter_search_product
      generate_filter 'search_key'
    end

    def filter_swearing
      generate_filter 'swearing'
    end

    def filter_search_venue
      generate_filter 'location'
    end

    def generate_filter(keyword_name)
      @context_keys[keyword_name].map do |v|
        Regexp.new(Regexp.quote(v), Regexp::IGNORECASE)
      end
    end
  end
end
