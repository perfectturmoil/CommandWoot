require 'rubygems'
require 'open-uri'
require 'json'

dans_api_key = "its a secret"

class Woot
	attr_reader :woot_site, :woot_api_url

	def initialize(woot_api_key, woot_site_input = nil)

		#based on the input choose what our woot site is - defined as an instance variable
		#just because

		if woot_site_input == nil       # I may want to remove this - no default, must be explicit
			@woot_site = "www.woot.com"
		else
			case woot_site_input.downcase
				when "woot"
					@woot_site = "www.woot.com"
				when "wine"
					@woot_site = "wine.woot.com"
				when "shirt"
					@woot_site = "shirt.woot.com"
				when "sellout"
					@woot_site = "sellout.woot.com"
				when "kids"
					@woot_site = "kids.woot.com"
				when "home"
					@woot_site = "home.woot.com"
				when "sport"
					@woot_site = "sport.woot.com"
				when "tech"
					@woot_site = "tech.woot.com"	
				else
					raise ArgumentError, "Sorry, #{woot_site_input} wasn't recognized as a woot site"
					#@woot_site = "www.woot.com"
			end
		end

		#generate woot API
		@woot_api_url = "http://api.woot.com/2/events.json?site=#{@woot_site}&eventType=Daily&key=#{woot_api_key}"

		#open the woot API, parse it with the JSOL library - create hash into parsed_woot_json
		@parsed_woot_json = JSON.parse(open(woot_api_url, 'r').read)

	end
	
	def summary
		@parsed_woot_json.each do |woot|
			puts "#{woot["Title"]} at #{woot["Site"]}"
	
			woot["Offers"][0]["Items"][0...3].each do |item|
				puts "\t#{item["SalePrice"]} - #{item["Title"]}" unless item["SoldOut"]
				puts "\tSold Out! - #{item["Title"]}" if item["SoldOut"]
			end
			puts "\t... and more!" if woot["Offers"][0]["Items"].count > 3
		end
	end

end

my_woot = Woot.new(dans_api_key, "shirt")
puts my_woot.woot_site
puts my_woot.woot_api_url
my_woot.summary

my_woot_2 = Woot.new(dans_api_key)    # on 12.12 this was broken.  
puts my_woot_2.woot_site
puts my_woot_2.woot_api_url
my_woot_2.summary



