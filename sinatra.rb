require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

get '/' do
    erb :index
end

post '/' do
    @system_name = params[:system_name]
    result = JSON.parse(Net::HTTP.post(URI("https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en"),["#{@system_name}"].to_json).body)
    
    abort @no_system="Такой системы нет!" unless result.key?("systems")
    
    system_id = result.dig('systems', 0, 'id')
    
    
    
    
    
    erb :index
end