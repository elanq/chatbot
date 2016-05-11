require 'telegram/bot'
require_relative './app/config.rb'
require_relative './app/bot.rb'

config = App::Config.new

bot_logic = App::Bot.new config.redis
Telegram::Bot::Client.run(config.tele_token) do |bot|
  bot.listen do |message|
    puts "-> #{message.from.username} : #{message.text}"
    bot_logic.process message
    reply = bot_logic.reply
    target = message.chat.id
    bot.api.send_message(chat_id: target, text: reply, parse_mode: 'Markdown', disable_web_page_preview: true)
    puts "##{reply} -> #{target}"
  end
end