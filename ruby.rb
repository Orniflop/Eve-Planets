require 'net/http'
require 'json'

res = Net::HTTP.post_form URI ('https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en'), 
{'names'=>'TTP-2B'}
puts res.body