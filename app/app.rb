# only used to bind required components
module App
  require 'net/http'
  require 'mechanize'
  require 'token'
  require 'json'
  require 'redis'
  require 'logger'
  require 'dotenv'
  require 'yaml'
  require 'date'
  require 'pry'
  require 'money'

  Dotenv.load
  Money.use_i18n = false

  require_relative 'client/client.rb'
  require_relative 'crawler/crawler.rb'
  require_relative 'service/service.rb'
  require_relative 'model/model.rb'
  require_relative 'helper/query.rb'
  require_relative 'bot.rb'
  require_relative 'config.rb'
end
