require_relative 'rspec_helper.rb'

def train
  @train ||= App::Crawler::Train.new
end

describe '#new' do
  it 'initate new instance of App::Crawler::Train' do
    expect(train).to be_an_instance_of App::Crawler::Train
  end

  it 'initiate new instance of mechanize' do
    mechanize = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    expect(mechanize).to be_an_instance_of Mechanize
  end
end

describe '#crawl' do
  it 'crawls for ticket schedules' do
    date = '20160615#'
    orig = 'BD#'
    dest = 'MN#'
    train.crawl date, orig, dest
    expect(train.result).not_to eq'Tidak ada jadwal tersedia'
    date = '20150615#'
    train.crawl date, orig, dest
    expect(train.result).to eq'Tidak ada jadwal tersedia'
  end
end
