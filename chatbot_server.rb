require 'telegram/bot'
require_relative './app/config.rb'
require_relative './app/bot.rb'

config = App::Config.new

bot_logic = App::Bot.new config
Telegram::Bot::Client.run(config.tele_token) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      bot_logic.handle_callback message
    end
    puts "-> #{message.from.username} : #{message.text}"
    bot_logic.process message
    reply = bot_logic.reply
    target = message.chat.id
    reply_markup = nil
    if bot_logic.request_location?
      bot.api.send_message(chat_id: target, text: 'Boleh kasih tahu lokasinya?')
      kb = [
              Telegram::Bot::Types::KeyboardButton.new(text: 'Sip', request_location: true, callback_data: 'confirm_location'),
              Telegram::Bot::Types::KeyboardButton.new(text: 'Jangan dong', callback_data: 'cancel_location')
            ]
      reply_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
    end

    opts = {
      chat_id: target,
      text: reply,
      parse_mode: 'Markdown',
      disable_web_page_preview: true
    }
    opts['reply_markup'] = reply_markup if bot_logic.request_location?

    bot.api.send_message(opts)
    puts "##{reply} -> #{target}"
  end
end