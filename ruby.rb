#подключаем внешний руби-код для методов JSON, net/http и uri
require 'net/http'
require 'uri'
require 'json'

system_name=gets.chomp #запрашиваем имя системы и обрезаем ей \n
result = Net::HTTP.post(URI("https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en"),
["#{system_name}"].to_json) #получаем данные с сайта в формате json
result = JSON.parse(result.body) #преобразуем JSON в хеш

if !(result.key?("systems")) #проверяем что это действительно солнечная система
    puts "Такой системы нет!"
    abort #прерываем программу
end

#получаем из хеша значение ключа, пример для TTP-2B: {"systems":[{"id":30000812,"name":"TTP-2B"}]}
result = result["systems"] #получаем [{"id":30000812,"name":"TTP-2B"}]
result = result[0] #получаем {"id":30000812,"name":"TTP-2B"}
system_id = result["id"] #получаем 30000812

#получаем информацию о системе по ее id
result = Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/systems/#{system_id}/?datasource=tranquility&language=en"))
result = JSON.parse(result)
result = result["planets"] #получаем массив хешей с планетами системы

#итерация массива для выбора всех planet_id и помещение их в массив
planets_id=[]
result.each do |planet_id|
    planets_id<<planet_id.dig("planet_id")
end

#получаем сведения по каждой планете и помещаем в массив ее name и type_id
planets=[]
planets_id.each do |planet_id|
    result = Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/planets/#{planet_id}/?datasource=tranquility"))
    result = JSON.parse(result)
    result = result.values_at("name","type_id")
    planets<<result
end

planets = planets.to_h #преобразуем массив в хеш

#по значению хеша получаем тип планеты ("Planet (Gas)"), обрезаем лишнее и в хеше меняем значение на тип планеты 
planets.each do |key, value|
    result = Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/types/#{value}/?datasource=tranquility&language=en"))
    result = JSON.parse(result)
    result = result["name"]
    result = result.chop.sub("Planet (", "") #обрезаем ) и "Planet (
    planets[key] = result
end

puts planets