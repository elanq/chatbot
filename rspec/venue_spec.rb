require_relative 'rspec_helper.rb'

describe '#new' do
  it 'initate new instance of App::Search::VenueSearch' do
    @product_search = App::Search::VenueSearch.new
    expect(@product_search).to be_an_instance_of App::Search::VenueSearch
  end
end

# describe '#search' do
#   it 'search product with product_search' do
#     @product_search = App::Search::VenueSearch.new
#     @opts = { keywords: 'sepeda balap', page: 0, per_page: 6 }
#     @message = @product_search.search @opts
#     puts @message
#   end

#   it 'search and paginate up to 3 pages' do
#     @product_search = App::Search::VenueSearch.new
#     (0..3).each do |itr|
#       @opts = { keywords: 'sepeda balap', page: itr, per_page: 6 }
#       @message = @product_search.search @opts
#       puts "page #{itr}"
#       puts @message
#     end
#   end
# end
