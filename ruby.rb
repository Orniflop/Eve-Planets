require 'net/http'
#require 'json'

uri = URI ('https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en')
res = Net::HTTP.post_form(uri, ['TTP-2B'])
puts res.body