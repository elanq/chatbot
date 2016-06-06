module App
  require_relative 'crawler/crawler.rb'
  require_relative 'search/search.rb'
  require_relative 'bot.rb'
  require_relative 'config.rb'

  require 'token'
  require 'json'
  require 'redis'
  require 'logger'
  require 'dotenv'
  require 'yaml'
end
