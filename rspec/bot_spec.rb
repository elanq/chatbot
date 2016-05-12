require_relative 'rspec_helper.rb'

def config
  @config ||= App::Config.new
end

def bot
  @bot ||= App::Bot.new config
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

describe '#bot_search' do
  def product_search
    App::Search::ProductSearch.new
  end

  def redis
    conf = App::Config.new
    conf.redis
  end

  context 'when accepting user input and process query' do
    def search(input)
      chat = Telegram::Bot::Types::Chat.new
      message = Telegram::Bot::Types::Message.new
      chat.id = 1234
      message.chat = chat
      message.text = input

      bot.process message
      puts bot.reply
    end

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
      search 'lagi dong'
      search 'lagi'
      # reset search
      search 'cari buku gambar'
      # move to different page for buku gambar
      search 'lagi'
    end
  end
end
