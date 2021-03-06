require_relative 'rspec_helper.rb'

RSpec.describe 'tiket crawler' do
  context '#init' do
    let(:tiket_crawler) { Crawler::Tiket.new }
    # let(:kereta_api) { Model::KeretaApi.new() }

    it 'create new Crawler::Tiket instance' do
      expect(tiket_crawler).to be_an_instance_of Crawler::Tiket
    end

    # it 'recognize Model::KeretaApi instance' do
    #   expect(kereta_api).to be_an_instance_of Model::KeretaApi
    # end
  end

  context '#crawl' do
    let(:tiket_crawler) { Crawler::Tiket.new }
    it 'crawl train ticket schedule'
    it 'crawl plane ticket schedule'
    it 'crawl available hotel rooms'
  end

  context '#request' do
    it 'redirect to tiket.com payment page'
  end
end
