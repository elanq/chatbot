require_relative 'rspec_helper.rb'

RSpec.describe 'venue' do
  context '#new' do
    it 'initate new instance of App::Search::VenueSearch' do
      @venue_search = App::Search::VenueSearch.new
      expect(@venue_search).to be_an_instance_of App::Search::VenueSearch
    end
  end

  context '#search' do
    it 'search venue with venue_search' do
      @venue_search = App::Search::VenueSearch.new
      @ll = '-6.2011036,106.7808587'
      @opts = { query: 'burger', ll: @ll, limit: 6 } # required params
      @message = @venue_search.search @opts
    end

    it 'search unknown venue' do
      @venue_search = App::Search::VenueSearch.new
      @ll = '-6.2011036,106.7808587'
      @opts = { query: 'fdsojfidfjo', ll: @ll, limit: 6 } # required params
      @message = @venue_search.search @opts
    end

    # it 'search and paginate up to 3 pages' do
    #   @venue_search = App::Search::VenueSearch.new
    #   (0..3).each do |itr|
    #     @opts = { keywords: 'sepeda balap', page: itr, per_page: 6 }
    #     @message = @venue_search.search @opts
    #     puts "page #{itr}"
    #     puts @message
    #   end
    # end
  end
end
