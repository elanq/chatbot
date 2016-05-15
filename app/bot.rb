require_relative '../app/search/product_search.rb'
require 'token'
require 'json'

module App
  # robot logic
  class Bot
    def initialize(config)
      @product_search = App::Search::ProductSearch.new
      @redis = config.redis
      @context_keys = config.keys['context']
    end

    def process(input)
      @message = nil
      message_text = input.text
      @user_reply_id = input.chat.id
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
          last_request_at: Time.now
        }
        save_search_term(search_term)
        do_search
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
      page = @redis.hget "chat-#{@user_reply_id}", 'current_page'
      page = @redis.hincrby "chat-#{@user}", 'current_page', 1 if search_more

      keywords.slice! keywords.split[0]
      opts = { keywords: keywords.strip!, per_page: 6, page: page }

      @message = @product_search.search opts
    end

    def filter_search_product
      @context_keys['search_key'].map do |v|
        Regexp.new(Regexp.quote(v), Regexp::IGNORECASE)
      end
    end

    def filter_swearing
      @context_keys['swearing'].map do |v|
        Regexp.new(Regexp.quote(v), Regexp::IGNORECASE)
      end
    end

    def filter_search_venue

    end
  end
end
