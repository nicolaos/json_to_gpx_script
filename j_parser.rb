require 'json'
require 'fileutils'
require 'builder'
require 'date'

file = File.open("workout.json", 'r')
contents = ""
file.each {|line|
  contents << line
}

array = JSON.parse(contents)

#navigo array
workout = array['workout']
data = workout['workout_date']
#puts data
#INIZIALIZZAZIONE TEMPI ---- 
tempo0 = DateTime.strptime(data, "%F %T CST%:z")
tempo0_time = tempo0.to_time


laps = workout['laps']

@prova = ""
builder = Builder::XmlMarkup.new(:target => @prova, :indent => 1)
builder.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" 
#<gpx xmlns="http://www.topografix.com/GPX/1/1" creator="NikePlus" version="1.1">
builder.gpx(:xmlns=>"http://www.topografix.com/GPX/1/1", :creator=>"nicolaosc", :version=>"1.1") do
	builder.trk do

		builder.trkseg do 

			laps.each do |n|
				numero = n['data_points']
				numero.each do |x|

					latlng = x['latlng']
					#puts latlng
					time = x['time']
					#aggiungi secondi segnati in quel punto
					time_tag = tempo0_time + time

					# primo giro non c'e' speed
					elevation = x['elevation']

					builder.trkpt(:lat => latlng[0], :lon => latlng[1]) do
						#elevazione
						# <ele>48.2530232204</ele>
						builder.ele elevation
						#time
						# <time>2010-09-09T07:18:04Z</time>
						builder.time time_tag.strftime("%FT%TZ")

					end
				end


			end
		end

	end
end
puts @prova

result = File.open("prova.gpx.xml", 'w+')
result.write @prova
