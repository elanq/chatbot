require 'telegram_bot'
require_relative './app/config.rb'
require_relative './app/bot.rb'

config = App::Config.new

bot_logic = App::Bot.new config.redis
bot = TelegramBot.new(token: config.tele_token)
bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    bot_logic.process command
    reply.parse_mode = 'Markdown'
    reply.text = bot_logic.reply
    reply.disable_web_page_preview = true
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
