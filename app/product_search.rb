require 'yaml'
require 'net/http'
require 'json'

module App
  # used to search product with BL Api and provide the result in message
  class ProductSearch
    def initialize
      endpoint = YAML.load(IO.read('app/endpoint.yml'))
      @uri = URI(endpoint['product_api'])
    end

    def search(opts = {})
      @keywords = opts[:keywords]
      @uri.query = ''
      @uri.query = URI.encode_www_form opts
      construct_message(JSON.parse(Net::HTTP.get(@uri)))
    end

    def construct_message(response)
      return 'tidak ada hasil' if response['products'].empty?
      response_message = "Hasil pencarian #{@keywords}\n"
      itr = 1
      response['products'].each do |p|
        response_message << "#{itr}. [#{p['name']}](#{p['url']}) \n"
        itr += 1
      end
      response_message << "\n ketik LAGI utk mencari #{@keywords} yang lainnya"
    end
  end
end
