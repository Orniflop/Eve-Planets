require 'net/http'
require 'uri'
require 'json'

res = Net::HTTP.post(URI("https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en"),
 "[\"TTP-2B\"]", "Content-Type" => "application/json") # вместо "[\"TTP-2B\"]" можно ["TTP-2B"].to_json
puts res.body