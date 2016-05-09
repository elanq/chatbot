require_relative 'rspec_helper.rb'

describe '#new' do
  context 'when creating bot instance' do
    it 'create new bot instance' do
      @bot = App::Bot.new
      expect(@bot).to be_an_instance_of App::Bot
    end
  end

  context 'when creating telegram bot instance' do
    it 'create telegram bot' do
      @config = App::Config.new
      @telegram_bot = TelegramBot.new(token: @config.token)
      expect(@telegram_bot).to be_an_instance_of TelegramBot::Bot
    end
  end
end

describe '#conn' do
  context 'when attempt a connection to redis server' do
    it 'create redis connection' do
      @config = App::Config.new
      @redis = @config.redis
      expect(@redis).to be_an_instance_of Redis
    end
  end

  context 'when set and get state to redis server' do
    it 'create state on redis server and retrieved' do
      @config = App::Config.new
      @redis = @config.redis
      @redis.set 'key', 'value'
      expect(@redis.get('key')).to be == 'value'
    end
  end
end
