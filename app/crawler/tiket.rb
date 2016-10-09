module Crawler
  # crawl tiket.com ticketing website
  class Tiket
    CRAWLER_TYPE = [
      :kereta_api,
      :hotel,
      :pesawat
    ].freeze

    def initialize
      @message = 'Pencarian tidak valid'
      @tiket_site = ENV['TIKET_TRAIN_WEB']
      @spider = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
      @respond = []
    end

    def crawl(input)
      return unless validate_input(input)
      params = parse_input(input)
      @tiket_site.query = URI.encode_www.form(params)
      @spider.get(@tiket_site) do |page|
        @message = 'Tidak ada kereta tersedia'
        schedule_lists = page.css('.search-list > table > #tbody_depart > tr')
        if schedule_lists.size > 0
          schedule_lists.each do |schedule|
            @respond.push(Model::KerataApi.new(schedule))
          end
        end
      end
    end

    def result
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
  end
end
