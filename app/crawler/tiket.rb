module Crawler
  # do the thing
  class Tiket
    CRAWLER_TYPE = [
      :kereta_api,
      :hotel,
      :pesawat
    ].freeze

    def initialize(type)
      @type = type
      raise Crawler::InvalidTiketType unless validate_type
      @model, url, @message, @css = init_type
      @tiket_site = URI(url)
      @spider = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
      @respond = []
    end

    def crawl(input)
      if validate_input(input)
        params = parse_input(input)
        @tiket_site.query = URI.encode_www_form(params)
        @spider.get(@tiket_site) do |page|
          schedule_lists = page.css(@css)
          if schedule_lists.size > 0
            schedule_lists.each do |schedule|
              begin
                @respond.push(@model.new(schedule))
              rescue Crawler::InvalidTableColumn => _e
                # just don't create this uncomplete model
                next
              end
            end
          end
        end
      end
    end

    def results
      @respond
    end

    private

    def validate_input(input)
      return true if input.split('#').size == 3
      false
    end

    def parse_input(input)
      parsed_input = input.split('#')
      params = {
        'd' => parsed_input[0],
        'a' => parsed_input[1],
        'date' => parsed_input[2],
        'ret_date' => '',
        'adult' => '1',
        'infant' => '0'
      }
      params
    end

    def init_type
      case @type
      when :kereta_api
        model = Model::KeretaApi
        url = ENV['TIKET_TRAIN_WEB']
        init_message = 'Tidak ada kereta tersedia'
        css = '.search-list > table > #tbody_depart > tr'
      when :pesawat
        model = Model::Pesawat
        url = ENV['TIKET_PLANE_WEB']
        init_message = 'Tidak ada pesawat tersedia'
        css = '.flight-single > .flight-list > table > #tbody_depart > tr'
      end

      [model, url, init_message, css]
    end

    def validate_type
      @type = @type.to_sym if @type.class == String
      CRAWLER_TYPE.include?(@type) || @type.class == Symbol
    end
  end
  # exception for invalid crawler type
  class InvalidTiketType < StandardError; end
  # exception for invalid column when parsing html
  class InvalidTableColumn < StandardError; end
end
