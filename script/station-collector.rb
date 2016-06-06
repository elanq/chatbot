require_relative 'script-helper.rb'

website = ENV['KERETA_API_WEB']
spiderman = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
spiderman.get(website) do |page|
  options = page.form_with(name: 'input').fields[1].options
  File.open('app/stations.yml', 'w+') do |f|
    opt = options.map do |o|
      val = o.value.split '#'
      { 'city_code' => val[0], 'city_name' => val[1] }
    end
    f.write opt.to_yaml
  end
end
