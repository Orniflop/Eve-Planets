require 'net/http'
require 'uri'
require 'json'

#uri = URI ('https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en')
#params = {:names => 'TTP-2B'}
#uri.query = URI.encode_www_form(params)
#res = Net::HTTP.get_response (uri)
#puts res.body


uri = URI ('https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en')
res = Net::HTTP.post_form(uri, ['names':'TTP-2B'])
puts res.body