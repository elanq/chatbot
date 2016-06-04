require_relative 'rspec_helper.rb'

describe '#new' do
  it 'initate new instance of App::Crawler::Train' do
    @train = App::Crawler::Train.new
    expect(@train).to be_an_instance_of App::Crawler::Train
  end
end
