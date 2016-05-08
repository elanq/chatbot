require 'yaml'
require 'net/http'
require 'json'

module App
  # used to search product with BL Api and provide the result in message
  class ProductSearch
    def initialize
      endpoint = YAML.load(IO.read('endpoint.yml'))
      @uri = Uri(endpoint)
    end

    def search(opts = {})
      @uri.query.clear
      @uri.query = URI.encode_www_form opts
      construct_message(JSON.parse(Net::HTTP(@uri)))
    end

    def construct_message(response)
      response_message = "Hasil pencarian \n"
      itr = 1
      response['products'].each do |p|
        response_message << "#{itr}. #{p['name']} \n"
        itr += 1
      end
      response_message
    end
  end
end
