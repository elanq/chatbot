require_relative '../app/product_search.rb'

module App
  # robot logic
  class Bot
    def initialize(redis)
      @product_search = App::ProductSearch.new
      @redis = redis
    end

    def process(input)
      @message = nil
      message_text = input.text
      user_reply_id = input.chat_id
      case message_text
      when /CARI/i
        @redis.set "chat-#{user_reply_id}", {last_keyword: message_text, current_page: 0}.to_json
        do_search
      when /BANTU/i, /TOLONG/i, /APA/i
        @message = "CARI <kata kunci> : mencari barang berdasarkan kata kunci\n"
      when /BUSUK/i, /BEGO/i, /TOLOL/i, /ANJING/i, /ASU/i
        @message = 'Omongannya dijaga bro ;)'
      when /LAGI/i
        # TODO : save page to redis server
        search_more true
      when /TEST/i
        @message = 'Saya online gan! apa yang bisa saya BANTU? :D'
      end
    end

    def reply
      @message ||= 'Maaf, perintah anda tidak saya ketahui. ketik BANTUAN untuk melihat daftar perintah saya!'
    end

    private

    def do_search(search_more = false)
      message_text.slice! message_text.split(' ')[0]
      opts = { keywords: message_text.strip!, per_page: 6 }
      @message = @product_search.search opts
    end
  end
end
