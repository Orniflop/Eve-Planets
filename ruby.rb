#задача: пользователь вводит название системы из вселенной игры eve-online, программа выдает сведения о наличии
#планет в системе (название и тип планеты). На примере системы TTP-2B.

#подключаем внешний руби-код для методов JSON, net/http и uri
require 'net/http'
require 'uri'
require 'json'

system_name=gets.chomp #запрашиваем у пользователя имя системы и обрезаем ей \n

#получаем данные с сайта в формате json и преобразуем их в хеш
result = JSON.parse(Net::HTTP.post(URI("https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en"),
["#{system_name}"].to_json).body)

#проверяем что это действительно солнечная система, иначе прерываем программу
abort "Такой системы нет!" unless result.key?("systems")

#получаем из хеша для TTP-2B: {"systems":[{"id":30000812,"name":"TTP-2B"}]} значение 30000812 
system_id = result.dig('systems', 0, 'id')

#получаем информацию о системе по ее id и из нее выбираем в массив хеши с планетами системы
result=JSON.parse(Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/systems/#{system_id}/?datasource=tranquility&language=en")))["planets"]

#итерация массива для выбора всех planet_id и помещение их в массив
planets_id=result.map{|x| x["planet_id"]}

#получаем сведения по каждой планете и помещаем в массив ее name и type_id
planets=[]
planets_id.each do |planet_id|
    planets<<JSON.parse(Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/planets/#{planet_id}/?datasource=tranquility"))).values_at("name","type_id")
end

planets = planets.to_h #преобразуем массив в хеш

#по значению хеша получаем тип планеты (например "Planet (Gas)"), обрезаем лишнее и в хеше меняем значение на тип планеты 
planets.each do |key, value|
    result = JSON.parse(Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/types/#{value}/?datasource=tranquility&language=en")))
    planets[key] = result["name"].chop.sub("Planet (", "") #берем из хеша значение и обрезаем ) и Planet (
end

puts planets