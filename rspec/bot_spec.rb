require_relative 'rspec_helper.rb'

def config
  @config ||= App::Config.new
end

def bot
  @bot ||= App::Bot.new config
end

def search(input)
  chat = Telegram::Bot::Types::Chat.new
  message = Telegram::Bot::Types::Message.new
  chat.id = 1234
  message.chat = chat
  message.text = input

  bot.process message
  # puts bot.reply
end

describe '#new' do
  context 'when creating bot instance' do
    it 'create new bot instance' do
      @bot = App::Bot.new config
      expect(@bot).to be_an_instance_of App::Bot
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
      search 'cari tempat burger'
      expect(bot.request_location?).to be true
      search 'cari kambing guling'
      expect(bot.request_location?).to be false
    end

    it 'return bot search information' do

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
      words = { 'carikan' => 'sepeda gunung',
                'cariin' => 'gelas cantik',
                'cari' => 'figure iron man' }
      words.each do |k, v|
        input = "#{k} #{v}"
        search input
      end
    end

    it 'search product with bukalapak api and move to different pages' do
      # search something first
      search 'carikan peralatan makan'
      # move to different page for peralatan makan
      search 'lagi'
      # reset search
      search 'cari buku gambar'
      # move to different page for buku gambar
      search 'lagi'
    end

    it 'search venue with foursquare api' do
      search 'cari alamat kfc'
    end
  end
end
