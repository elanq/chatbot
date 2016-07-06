# only used to bind required components
module App
  require_relative 'crawler/crawler.rb'
  require_relative 'search/search.rb'
  require_relative 'model/model.rb'
  require_relative 'bot.rb'
  require_relative 'config.rb'

  require 'net/http'
  require 'mechanize'
  require 'token'
  require 'json'
  require 'redis'
  require 'logger'
  require 'dotenv'
  require 'yaml'
  require 'date'
end
