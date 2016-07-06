module Crawler
    # crawl kai ticketing website
    class Train
    	def initialize
    		@train_site = ENV['KERETA_API_WEB']
    		@message = 'Pencarian tidak valid'
    		@spiderman = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    		@stations = YAML.load_file 'app/stations.yml'
    	end

    	def crawl(input, option = {})
    		splitted = input.split '#'
    		unless splitted.size == 3
    			@message = 'Format pencarian salah'
    			return
    		end
    		date = "#{splitted[0]}#"
    		origin = search_station "#{splitted[1]}"
    		destination = search_station "#{splitted[2]}"
    		default_option = {
    			adult: 1,
    			infant: 0
    		}
    		if origin.nil? || destination.nil?
    			@message = 'Nama stasiun tidak dikenal, coba lagi'
    			return
    		end
    		origin = "#{origin['city_code']}#"
    		destination = "#{destination['city_code']}#"

    		option = default_option.merge(option)
    		@spiderman.get(@train_site) do |page|
    			search = page.form_with(name: 'input') do |f|
    				f.tanggal = date
    				f.origination = origin
    				f.destination = destination
    				f.adult = option[:adult]
    				f.infant = option[:infant]
    			end.submit
    			schedules = filter_schedule search
    			@message = schedules.empty? ? 'Tidak ada jadwal tersedia' : construct_message(schedules)
    		end
    	end

    	def result
    		@message
    	end

    	private

    	def search_station(query)
    		@stations.find do |v|
    			v['city_name'] == query.upcase
    		end
    	end

    	def construct_message(schedules)
    		@message = ''
    		schedules.each do |schedule|
          # assign manually. because apparently our useful information provided in array. not hash. duh dek
          train_name = schedule.fields[6].value.capitalize
          raw_departure = "#{schedule.fields[7].value}#{schedule.fields[8].value}"
          raw_arrival = "#{schedule.fields[9].value}#{schedule.fields[10].value}"
          departure_datetime = DateTime.strptime(raw_departure, '%Y%m%d%H%M').strftime('%c')
          arrival_datetime = DateTime.strptime(raw_arrival, '%Y%m%d%H%M').strftime('%c')
          money = schedule.fields[13].value.to_i
          seat = schedule.fields[15].value.to_i

          @message << "#{train_name} #{departure_datetime} - #{arrival_datetime} seharga #{money} sisa #{seat}\n"
        end
        @message
      end

      def filter_schedule(search)
      	search.forms.select { |f| f.name !~ /input/ && f.fields.last.value == 'true' }
      end
    end
  end
