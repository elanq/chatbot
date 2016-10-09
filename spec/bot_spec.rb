require_relative 'rspec_helper.rb'

RSpec.describe 'bot' do
  def config
    @config ||= App::Config.new
  end

  def bot
    @bot ||= Bot.new config
  end

  def logger
    @logger ||= config.logger
  end

  def chat(input)
    message = input
    message = build_message(input) unless input.class == Telegram::Bot::Types::Message
    bot.process message
    # puts bot.reply
  end

  def build_message(text)
    chat = Telegram::Bot::Types::Chat.new
    message = Telegram::Bot::Types::Message.new
    chat.id = 1234
    message.chat = chat
    message.text = text
    message
  end

  def add_location(message)
    location = Telegram::Bot::Types::Location.new
    location.latitude = -6.273891
    location.longitude = 106.8202928
    message.location = location
    message
  end

  describe '#new' do
    context 'when creating bot instance' do
      it 'create new bot instance' do
        @bot = Bot.new config
        expect(@bot).to be_an_instance_of Bot
      end
    end
  end

  describe '#conn' do
    context 'when attempt a connection to redis server' do
      it 'create redis connection' do
        expect(config.redis).to be_an_instance_of Redis
      end
    end

    context 'when set and get state to redis server' do
      it 'create state on redis server and retrieved' do
        config.redis.set 'key', 'value'
        expect(config.redis.get('key')).to be == 'value'
      end
    end
  end

  describe '#bot_learning' do
    context 'when user inputting search query' do
      it 'should able to differentiate between product or venue search' do
        chat '/carilokasi burger'
        expect(bot.request_location?(1234)).to be true
        chat '/caribarang piring cantik'
        expect(bot.request_location?(1234)).to be false
      end

      it 'should know that user needs helping' do
        chat 'tolong'
        expect(bot.reply).to eq "/caribarang <nama barang> untuk mencari barang yang tersedia di bukalapak.com\n /carilokasi untuk mencari lokasi di sekitar kamu\n\n Untuk diperhatikan bahwa bot ini hanya bisa memahami perintah-perintah diatas. Jadi kalau mau aneh-aneh disini bukan tempatnya yaaaa"
      end
    end
  end

  describe '#bot_search' do
    def product_search
      App::Search::ProductSearch.new
    end

    def redis
      conf = App::Config.new
      conf.redis
    end

    context 'when accepting user input and process query' do
      it 'search product with bukalapak api' do
        words = ['sepeda gunung', 'gelas cantik', 'figure iron man']
        words.each do |_k, v|
          input = "/caribarang #{v}"
          chat input
        end
      end

      it 'search product with bukalapak api and move to different pages' do
        # search something first
        chat '/caribarang peralatan makan'
        # move to different page for peralatan makan
        chat 'lagi'
        # reset
        chat '/caribarang buku gambar'
        # move to different page for buku gambar
        chat 'lagi'
      end

      it 'search venue with foursquare api' do
        message = build_message '/carilokasi burger king'
        chat message
        expect(bot.request_location?(1234)).to be true
      end
    end
  end
end
