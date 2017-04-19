module Model
  class Chat
    def initialize(input_message)
      @input_message = input_message
      @product_search ||= App::Search::ProductSearch.new
      @venue_search ||= App::Search::VenueSearch.new
      @train_schedule_search ||= Crawler::Train.new
      @logger ||= Config.logger
      @redis ||= Config.redis
      parse_message
    end

    def input_text
      @input_message.text
    end

    def reply_text
      @message ||= "Perintah tidak dikenali"
    end

    def user_reply_id
      @input_message.chat.id
    end

    def contains_location?
      false
    end

    def contains_image?
      false
    end
  end
end
