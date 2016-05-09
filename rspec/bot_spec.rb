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

  context 'when creating telegram bot instance' do
    it 'create telegram bot' do
      @config = App::Config.new
      @telegram_bot = TelegramBot.new(token: @config.tele_token)
      expect(@telegram_bot).to be_an_instance_of TelegramBot::Bot
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
    it 'search product with bukalapak api' do
      input = 'CARI sepeda scott'
      bot.process input
      puts bot.reply
    end
  end
end
