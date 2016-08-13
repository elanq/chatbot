require_relative '../app/app.rb'
require 'telegram/bot'
require 'pry'

Dotenv.load

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end
