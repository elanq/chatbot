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
