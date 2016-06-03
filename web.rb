require 'telegram/bot'
require_relative './app/config.rb'
require_relative './app/bot.rb'

config = App::Config.new

bot_logic = App::Bot.new config
logger = config.logger
Telegram::Bot::Client.run(config.tele_token, logger: logger) do |bot|
  bot.listen do |message|
    processed = false
    reply_markup = nil
    unless message.location.nil?
      logger.info 'this message contains location'
      lat = message.location.latitude
      lng = message.location.longitude
      bot_logic.handle_location(lat, lng) if bot_logic.request_location?(message.chat.id)
      processed = true
    end

    bot_logic.process(message) unless processed
    if bot_logic.request_location?(message.chat.id)
      kb = [Telegram::Bot::Types::KeyboardButton.new(text: 'Kirim lokasi sekarang', request_location: true)]
      reply_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
    end

    reply = bot_logic.reply
    target = message.chat.id

    opts = {
      chat_id: target,
      text: reply,
      parse_mode: 'Markdown',
      disable_web_page_preview: true
    }
    opts['reply_markup'] = reply_markup if bot_logic.request_location?(target)

    bot.api.send_message(opts)
    logger.info "##{reply} -> #{target}"
  end
end