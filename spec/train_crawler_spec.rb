require_relative 'rspec_helper.rb'

RSpec.describe 'train  crawler' do
  def train
    @train ||= Crawler::Train.new
  end

  describe '#new' do
    it 'initate new instance of Crawler::Train' do
      expect(train).to be_an_instance_of Crawler::Train
    end

    it 'initiate new instance of mechanize' do
      mechanize = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
      expect(mechanize).to be_an_instance_of Mechanize
    end
  end

  describe '#crawl' do
    let(:date) { Date.today.next_month.strftime('%Y%m%d') }
    it 'crawls for ticket schedules' do
      input = "#{date}#Bandung#Madiun"
      train.crawl input
      expect(train.result).not_to eq'Tidak ada jadwal tersedia'
      modified_input = '20150615#Bandung#Madiun'
      train.crawl modified_input
      expect(train.result).to eq 'Tidak ada jadwal tersedia'
    end

    it 'show errors for invalid input'do
      invalid_city_input = '20160615#Badung#Madiun'
      train.crawl invalid_city_input
      expect(train.result).to eq 'Nama stasiun tidak dikenal, coba lagi'
      invalid_format = 'luullsss'
      train.crawl invalid_format
      expect(train.result).to eq('Format pencarian salah')
    end
  end
end
