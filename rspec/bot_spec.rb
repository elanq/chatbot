require_relative 'rspec_helper.rb'

def config
  @config ||= App::Config.new
end

def bot
  @bot ||= App::Bot.new config.redis
end

describe '#new' do
  context 'when creating bot instance' do
    it 'create new bot instance' do
      @bot = App::Bot.new config.redis
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
    App::ProductSearch.new
  end

  def redis
    conf = App::Config.new
    conf.redis
  end

  context 'when accepting user input and process query' do
    def search(input)
      bot.process input
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
  end
end
