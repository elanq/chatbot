require_relative 'script_helper.rb'

@tiket_site = URI(ENV['TIKET_TRAIN_WEB'])
@spider = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
params = {
  'd' => 'SMT',
  'a' => 'GMR',
  'date' => '2016-08-10',
  'ret_date' => '',
  'adult' => '1',
  'infant' => '0'
}
@tiket_site.query = URI.encode_www_form(params)
@spider.get(@tiket_site) do |page|
  schedule_lists = page.css('.search-list > table > #tbody_depart > tr')
  schedule_lists.each do |schedule|
    train_name = schedule.css('.td1').first.text.strip
    train_departure = schedule.css('.td2').first.text.strip
    train_arrival = schedule.css('.td3').first.text.strip

    puts "#{train_name} #{train_departure} #{train_arrival}"
  end
end
