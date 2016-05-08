require_relative 'rspec_helper.rb'

describe App::ProductSearch do
end

describe '#new' do
  it 'initate new instance of App::ProductSearch' do
    @product_search = App::ProductSearch.new
    expect(@product_search).to be_an_instance_of App::ProductSearch
  end
end

describe '#search' do
  it 'search product with product_search' do
    @product_search = App::ProductSearch.new
    @opts = { keywords: 'sepeda balap', page: 0, per_page: 20 }
    @message = @product_search.search @opts
    puts @message
  end

  it 'paginate 10 search result' do
    (0..10).each do |itr|
      @product_search = App::ProductSearch.new
      @opts = { keywords: 'sepeda balap', page: itr, per_page: 20 }
      @message = @product_search.search @opts
      puts "page #{itr}"
      puts @message
    end
  end
end
