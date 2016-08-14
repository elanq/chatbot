require_relative 'rspec_helper.rb'

RSpec.describe 'tiket crawler' do
  let(:kereta_crawler) { Crawler::Tiket.new(:kereta_api) }
  let(:hotel_crawler) { Crawler::Tiket.new(:kereta_api) }
  let(:pesawat_crawler) { Crawler::Tiket.new(:kereta_api) }
  context '#init' do
    it 'create new Crawler::Tiket instance' do
      expect(kereta_crawler).to be_an_instance_of Crawler::Tiket
    end
  end

  context '#crawl' do
    it 'crawl train ticket schedule' do
      param = 'SMT#GMR#2016-10-01'
      kereta_crawler.crawl(param)
      expect(kereta_crawler.results).to be_an_instance_of(Array)
      expect(kereta_crawler.results.first).to be_an_instance_of(Model::KeretaApi) unless kereta_crawler.results.empty?
    end
    it 'crawl plane ticket schedule' do
      param = 'CGK#DPS#2016-10-01'
      pesawat_crawler.crawl(param)
      expect(pesawat_crawler.results).to be_an_instance_of(Array)
      expect(pesawat_crawler.results.first).to be_an_instance_of(Model::Pesawat) unless pesawat_crawler.results.empty?
    end
    it 'crawl available hotel rooms'
  end

  context '#request' do
    it 'redirect to tiket.com payment page'
  end
end

