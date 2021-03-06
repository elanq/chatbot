# robot logic
class Bot
  # initialize bot
  def initialize
    @product_search ||= App::Service::ProductSearch.new
    @venue_search ||= App::Service::VenueSearch.new
    @banker_service ||= Service::BankerService.new
    @train_schedule_search ||= Crawler::Train.new
    @redis ||= Config.redis
    @logger ||= Config.logger
    @banker_client ||= Config.banker_client
  end

  # is bot requesting location? return true if it is
  def request_location?(reply_id)
    request_location = @redis.hget "chat-#{reply_id}", 'request_location'
    @logger.info "location request status : #{request_location}"
    request_location == 'false' ? false : true
  end

  # is bot requesting ticketing detail?
  def request_ticketing?(reply_id)
    request_ticketing = @redis.hget "chat-#{reply_id}", 'request_ticketing'
    request_ticketing == 'true' ? true : false
  end

  # processing query.
  # complex conditioning ahead
  def process(input, file = nil)
    # reset params
    @logger.info 'reset search parameters'
    @message = nil
    message_text = input.text
    @user_reply_id = input.chat.id
    # set default request to false
    save_command request_location: false

    case message_text
    when /start/i
      @message = welcome
    when Query.asking_help?
      @message = help_message
    when Query.asking_more?
      search_product true
    when Query.testing_connection?
      @message = 'Saya online gan! apa yang bisa saya BANTU? :D'
    else
      process_command(message_text, file)
      if request_ticketing?(@user_reply_id)
        @train_schedule_search.crawl message_text
        @message = @train_schedule_search.result
        save_command request_ticketing: false
      end
    end
  end

  # handlng message with location
  def handle_location(lat, lng)
    @logger.info "handle location with lat #{lat} and lng #{lng}"
    search_venue lat, lng
  end

  # get bot reply message
  def reply
    @message ||= 'Maaf, perintah anda tidak saya ketahui. ketik BANTU untuk melihat daftar perintah saya!'
  end

  private

  def process_command(input, file = nil)
    case input
    # cektabungan/MM/YY
    # specify month as 00 to receive yearly summary
    when /cektabungan/i
      @message = "sedang mengecek penghasilan kamu..."
      command = {
        action: 'cek_tabungan',
        last_request_at: Time.now,
        keywords: input
      }
      save_command(command)
      check_saving
    when /cektiket/i
      @message = cektiket_disclaimer
      command = {
        action: 'cek_tiket',
        last_request_at: Time.now,
        request_ticketing: true
      }
      save_command command
    when /caribarang/i
      command = {
        action: 'cari_barang',
        keywords: input,
        current_page: 0,
        last_request_at: Time.now
      }
      save_command(command)
      search_product
    when /carilokasi/i
      last_location = last_saved_location
      command = {
        action: 'cari_lokasi',
        venue_keywords: input,
        last_request_at: Time.now,
        request_location: last_location.empty? ? true : false
      }
      save_command command
      last_location.empty? ? @message = 'Bisa minta lokasi sekarang?' : handle_location(last_location[0], last_location[1])
    end
    false
  end
  # TODO:  These response needed to be refactored ASAP
  def welcome
    'Halo, saya asisten robot ciptaan @qisthi yang bisa membantu kamu untuk mendapatkan informasi-informasi yang kamu butuhkan. Tulis BANTU untuk melihat daftar perintah yang saya ketahui :D'
  end

  def cektiket_disclaimer
    "Fitur ini masih eksperimental dan sangat terbatas fungsionalitasnya. Untuk sekarang, perintah ini hanya support untuk mengecek ketersediaan tiket kereta dan tidak support untuk pemesanaan tiket.\n\n Silahkan masukkan balas dengan format berikut untuk melihat kesediaan tiket kereta\ntanggalpesan#dari#tujuan\ncontoh: 20161231#Bandung#Gambir"
  end

  # help message
  def help_message
    "/caribarang <nama barang> untuk mencari barang yang tersedia di bukalapak.com\n /carilokasi untuk mencari lokasi di sekitar kamu\n\n Untuk diperhatikan bahwa bot ini hanya bisa memahami perintah-perintah diatas. Jadi kalau mau aneh-aneh disini bukan tempatnya yaaaa"
  end

  # set search param to redis
  def save_command(command)
    command.each do |k, v|
      @redis.hset "chat-#{@user_reply_id}", k, v
    end
  end

  # set message expired time
  def save_last_location(last_location, timeout = 3600)
    @logger.info "saving last location at #{last_location}"
    key = "chat-#{@user_reply_id}-last_location"
    saved_status = @redis.get(key).nil?
    @redis.set(key, last_location, ex: timeout) if saved_status
    @logger.info "saved status is #{saved_status}"
  end

  # retrieve last location saved in redis
  def last_saved_location
    ll = []
    key = "chat-#{@user_reply_id}-last_location"
    ttl_status = @redis.get key
    ll = @redis.get(key).split(',').map(&:to_f) unless ttl_status.nil?
    @logger.info "last saved location at #{ll ||= 'empty'}"
    ll
  end

  # search product
  def search_product(search_more = false)
    keywords = @redis.hget "chat-#{@user_reply_id}", 'keywords'
    @message = 'Terjadi kesalahan dalam pencarian barang'
    return if keywords.nil?
    page = @redis.hget "chat-#{@user_reply_id}", 'current_page'
    page = @redis.hincrby "chat-#{@user}", 'current_page', 1 if search_more

    keywords.slice! keywords.split[0]
    opts = { keywords: keywords.strip!, per_page: 6, page: page }

    @message = @product_search.search(opts)
    save_command request_location: false
  end

  def check_saving
    keywords = @redis.hget "chat-#{@user_reply_id}", 'keywords'
    @message = 'Terjadi kesalahan dalam pengecekan tabungan'
    return if keywords.nil?

    params = keywords.split('#')
    month = params[1]
    year = params[2]
    return if month.nil? || year.nil?
    @message = @banker_service.summary(month, year)
  end

  # search venue
  def search_venue(lat, long)
    query = @redis.hget "chat-#{@user_reply_id}", 'venue_keywords'
    @logger.info "search venue query #{query ||= 'is empty'}"
    @message = 'Terjadi kesalahan dalam pencarian lokasi'
    return if query.nil?
    query.slice! query.split[0]

    @logger.info "search venue with query'#{query}'"
    ll = "#{lat},#{long}"
    opts = { query: query, limit: 6, ll: ll }
    @venue_search.origin_location = ll
    @message = @venue_search.search(opts)
    @logger.info "search venue completed, return message '#{@message}'"
    # change request status back to false
    save_command request_location: false
    save_last_location ll if last_saved_location.empty?
  end
end
