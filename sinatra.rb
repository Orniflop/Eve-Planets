require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

get '/' do
    erb :index
end

post '/' do
    @system_name = params[:system_name]
    @result = JSON.parse(Net::HTTP.post(URI("https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en"),["#{@system_name}"].to_json).body)
    erb :index
end