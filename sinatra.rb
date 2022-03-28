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
    
    if result.has_key?("systems")==false
        @message="Такой системы нет!"

    else
        system_id = result.dig('systems', 0, 'id')
        result=JSON.parse(Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/systems/#{system_id}/?datasource=tranquility&language=en")))["planets"]
        planets_id=result.map{|x| x["planet_id"]}
        
        planets=[]
        planets_id.each do |planet_id|
            planets<<JSON.parse(Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/planets/#{planet_id}/?datasource=tranquility"))).values_at("name","type_id")
        end
        
        planets = planets.to_h
            
        planets.each_pair do |key, value|
            planets[key] = JSON.parse(Net::HTTP.get(URI("https://esi.evetech.net/latest/universe/types/#{value}/?datasource=tranquility&language=en")))["name"].chop.sub("Planet (", "")
        end

        @planets_screen=[]
        planets.each do |key, value|
            @planets_screen << "#{key.to_s} - #{value.to_s}"
        end

        Raw_Resource={"Aqueous Liquids"=>["Barren","Storm","Temperate","Ice","Gas","Oceanic"],"Autotrophs"=>["Temperate"],"Base Metals"=>["Barren","Storm","Gas","Plasma","Lava"],"Carbon Compounds"=>["Barren","Temperate","Oceanic"],"Complex Organisms"=>["Temperate","Oceanic"],"Felsic Magma"=>["Lava"],"Heavy Metals"=>["Ice","Plasma","Lava"],"Ionic Solutions"=>["Storm","Gas"],"Microorganisms"=>["Barren","Temperate","Ice","Oceanic"],"Noble Gas"=>["Storm","Ice","Gas"],"Noble Metals"=>["Barren","Plasma"],"Non-CS Crystals"=>["Plasma","Lava"],"Planktic Colonies"=>["Ice","Oceanic"],"Reactive Gas"=>["Gas"],"Suspended Plasma"=>["Storm","Plasma","Lava"]}
        Tier1={"Aqueous Liquids"=>["Water"],"Autotrophs"=>["Industrial Fibers"],"Base Metals"=>["Reactive Metals"],"Carbon Compounds"=>["Biofuels"],"Complex Organisms"=>["Proteins"],"Felsic Magma"=>["Silicon"],"Heavy Metals"=>["Toxic Metals"],"Ionic Solutions"=>["Electrolytes"],"Microorganisms"=>["Bacteria"],"Noble Gas"=>["Oxygen"],"Noble Metals"=>["Precious Metals"],"Non-CS Crystals"=>["Chiral Structures"],"Planktic Colonies"=>["Biomass"],"Reactive Gas"=>["Oxidizing Compound"],"Suspended Plasma"=>["Plasmoids"]}
        Tier2={"Biocells"=>["Biofuels","Precious Metals"],"Construction Blocks"=>["Toxic Metals","Reactive Metals"],"Consumer Electronics"=>["Toxic Metals", "Chiral Structures"],"Coolant"=>["Electrolytes","Water"],"Enriched Uranium"=>["Toxic Metals","Precious Metals"],"Fertilizer"=>["Bacteria","Proteins"],"Genetically Enhanced Livestock"=>["Proteins","Biomass"],"Livestock"=>["Biofuels","Proteins"],"Mechanical Parts"=>["Reactive Metals","Precious Metals"],"Microfiber Shielding"=>["Silicon","Industrial Fibers"],"Miniature Electronics"=>["Silicon","Chiral Structures"],"Nanites"=>["Reactive Metals","Bacteria"],"Oxides"=>["Oxidizing Compound","Oxygen"],"Polyaramids"=>["Oxidizing Compound","Industrial Fibers"],"Polytextiles"=>["Biofuels","Industrial Fibers"],"Rocket Fuel"=>["Electrolytes","Plasmoids"],"Silicate Glass"=>["Oxidizing Compound","Silicon"],"Superconductors"=>["Plasmoids","Water"],"Supertensile Plastics"=>["Oxygen","Biomass"],"Synthetic Oil"=>["Electrolytes","Oxygen"],"Test Cultures"=>["Bacteria","Water"],"Transmitter"=>["Chiral Structures","Plasmoids"],"Viral Agent"=>["Bacteria","Biomass"],"Water-Cooled CPU"=>["Reactive Metals","Water"]}
        Tier3={"Biotech Research Reports"=>["Construction Blocks","Livestock","Nanites"],"Camera Drones"=>["Rocket Fuel","Silicate Glass"],"Condensates"=>["Coolant","Oxides"],"Cryoprotectant Solution"=>["Synthetic Oil","Fertilizer","Test Cultures"],"Data Chips"=>["Supertensile Plastics","Microfiber Shielding"],"Gel-Matrix Biopaste"=>["Superconductors","Biocells","Oxides"],"Guidance Systems"=>["Water-Cooled CPU","Transmitter"],"Hazmat Detection Systems"=>["Transmitter","Viral Agent","Polytextiles"],"Hermetic Membranes"=>["Polyaramids","Genetically Enhanced Livestock"],"High-Tech Transmitters"=>["Transmitter","Polyaramids"],"Industrial Explosives"=>["Fertilizer","Polytextiles"],"Neocoms"=>["Biocells","Silicate Glass"],"Nuclear Reactors"=>["Enriched Uranium","Microfiber Shielding"],"Planetary Vehicles"=>["Supertensile Plastics","Miniature Electronics","Mechanical Parts"],"Robotics"=>["Consumer Electronics","Mechanical Parts"],"Smartfab Units"=>["Miniature Electronics","Construction Blocks"],"Supercomputers"=>["Water-Cooled CPU","Coolant","Consumer Electronics"],"Synthetic Synapses"=>["Supertensile Plastics","Test Cultures"],"Transcranial Microcontrollers"=>["Biocells","Nanites"],"Ukomi Superconductors"=>["Superconductors","Synthetic Oil"],"Vaccines"=>["Livestock","Viral Agent"]}
        Tier4={"Broadcast Node"=>["Data Chips","Neocoms","High-Tech Transmitters"],"Integrity Response Drones"=>["Gel-Matrix Biopaste","Planetary Vehicles","Hazmat Detection Systems"],"Nano-Factory"=>["Industrial Explosives","Ukomi Superconductors","Reactive Metals"],"Organic Mortar Applicators"=>["Condensates","Robotics","Bacteria"],"Recursive Computing Module"=>["Synthetic Synapses","Transcranial Microcontrollers","Guidance Systems"],"Self-Harmonizing Power Core"=>["Nuclear Reactors","Camera Drones","Hermetic Membranes"],"Sterile Conduits"=>["Vaccines","Water","Smartfab Units"],"Wetware Mainframe"=>["Biotech Research Reports","Supercomputers","Cryoprotectant Solution"]}

        system_Raw_Resource = []
        planets.each_value do |value1|
            Raw_Resource.each do |key, value2|
                system_Raw_Resource<<key if value2.include?(value1)
            end
        end
        @system_Raw_Resource = system_Raw_Resource.uniq

        @system_tier1 = []
        system_Raw_Resource.each do |value1|
            Tier1.each do |key, value2|
                @system_tier1 << value2[0] if key.include?(value1)
            end
        end

        def system_tiers23 (arr1, arr2)
            arr3=[]
            arr1.each do |key, value|
                arr3 << key if value.difference(arr2).empty?
            end
            return arr3    
        end
        
        @system_tier2 = system_tiers23(Tier2, @system_tier1)
        @system_tier3 = system_tiers23(Tier3, @system_tier2)

        @system_tier4 = []
        Tier4.each do |key, value|
            @system_tier4 << key if value.difference(@system_tier3+@system_tier1).empty?
        end

        erb :index

    end
end