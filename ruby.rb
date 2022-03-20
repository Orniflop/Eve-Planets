#подключаем внешний руби-код для методов JSON, net/http и uri
require 'net/http'
require 'uri'
require 'json'

system_name=gets.chomp #запрашиваем имя системы и обрезаем ей \n
result = Net::HTTP.post(URI("https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en"),
["#{system_name}"].to_json) #получаем данные с сайта в формате json
result=JSON.parse(result.body) #преобразуем JSON в хеш

if !(result.key?("systems")) #проверяем что это действительно солнечная система
    puts "Такой системы нет!"
    abort #прерываем программу
end

result=result["systems"]
#result=result.to_s
result=result["id"]
#result=result.values_at("name")
#result=result.to_s
#result=result.inspect

 
puts result




 #{"systems":[{"id":30000812,"name":"TTP-2B"}]} для TTP-2B