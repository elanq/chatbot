require_relative '../app/search/search.rb'
require_relative '../app/search/product_search.rb'
require_relative '../app/search/venue_search.rb'
require_relative '../app/crawler/crawler.rb'
require_relative '../app/crawler/train.rb'
require_relative '../app/bot.rb'
require_relative '../app/config.rb'
require 'telegram/bot'
require 'dotenv'

Dotenv.load
