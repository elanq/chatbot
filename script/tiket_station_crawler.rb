require_relative 'script_helper'

tiket_web = ENV['TIKET_WEB']
spiderman = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
spiderman.get(tiket_web) do |page|
  _list = page.css('.list').css('.all_station_dropdown')
end
