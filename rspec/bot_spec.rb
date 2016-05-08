require_relative 'rspec_helper.rb'

describe '#new' do
  context 'when creating bot instance' do
    it 'create new bot instance' do
      @bot = App::Bot.new
      expect(@bot).to be_an_instance_of App::Bot
    end
  end
end