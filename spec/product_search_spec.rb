require_relative 'rspec_helper.rb'

RSpec.describe 'product search' do
  context '#new' do
    it 'initate new instance of App::Search::ProductSearch' do
      @product_search = App::Search::ProductSearch.new
      expect(@product_search).to be_an_instance_of App::Search::ProductSearch
    end
  end

  context '#search' do
    it 'search product with product_search' do
      @product_search = App::Search::ProductSearch.new
      @opts = { keywords: 'sepeda balap', page: 0, per_page: 6 }
      @message = @product_search.search @opts
    end

    it 'search and paginate up to 3 pages' do
      @product_search = App::Search::ProductSearch.new
      (0..3).each do |itr|
        @opts = { keywords: 'sepeda balap', page: itr, per_page: 6 }
        @message = @product_search.search @opts
      end
    end
  end
end
