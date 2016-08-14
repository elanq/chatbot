require_relative 'script_helper.rb'

@tiket_site = URI(ENV['TIKET_TRAIN_WEB'])
@spider = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
params = {
  'd' => 'SMT',
  'a' => 'GMR',
  'date' => '2016-10-01',
  'ret_date' => '',
  'adult' => '1',
  'infant' => '0'
}
@tiket_site.query = URI.encode_www_form(params)
@spider.get(@tiket_site) do |page|
  schedule_lists = page.css('.search-list > table > #tbody_depart > tr')
  puts 'tidak ada jadwal tersedia' if schedule_lists.empty?
  schedule_lists.each do |schedule|
    train_schedule = Model::KeretaApi.new(schedule)
    puts train_schedule
    # column_1 = schedule.css('.td1').first.text.strip.gsub(/\n\t+/, '#').split('#')
    # train_name = column_1[0]
    # train_class = column_1[1]

    # column_2 = schedule.css('.td2').first.text.strip.gsub(/\n\t+/, '#').split('#')
    # train_departure_time = column_2[0]
    # train_departure_dest = column_2[1]

    # column_3 = schedule.css('.td3').first.text.strip.gsub(/\n\t+/, '#').split('#')
    # train_arrival_time = column_3[0]
    # train_arrival_dest = column_3[1]

    # link_selector = schedule.css('.td6 > div > a')
    # link = 'Not available'
    # link = link_selector.first['href'] unless link_selector.empty?
    # puts "#{train_name} #{train_departure_dest} to #{train_arrival_dest} #{link}"
  end
end
