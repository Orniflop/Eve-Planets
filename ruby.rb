#подключаем внешний руби-код для методов JSON, net/http и uri
require 'net/http'
require 'uri'
require 'json'

result = Net::HTTP.post(URI("https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en"),
["TTP-2B"].to_json) #получаем данные с сайта в формате json
result=JSON.parse(result.body) #преобразуем JSON в хеш
puts "Такой системы нет!" if !(result.key?("systems")) #проверяем что это действительно солнечная система

#result=result.inspect

 
puts result


#result.values_at("systems")

 #result.inspect превращает хеш в строку

 #{"systems":[{"id":30000812,"name":"TTP-2B"}]}
 #добавить проверку если хеш не содержит "systems": значит это не система и выводить ошибку