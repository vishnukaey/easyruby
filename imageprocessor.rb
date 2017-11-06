require 'open-uri'
require 'nokogiri'
require 'pg'



module DBConnector
	def set_connection
		@con = PG.connect :dbname => 'easyruby', :user => 'postgres', 
		:password => 'qburst'
		@con
	end

	def close_connection
		@con.close if @con
	end
end 



class ImageProcessor 
	include DBConnector
	attr_accessor :con

	def initialize(url)
		set_connection
		@url = url
	end

	def download_images
		url_string = @url.chomp
		arr =Array.new
		Nokogiri::HTML(open(url_string)).xpath("//img/@src").each do |src|
  			uri = URI.join(url_string, src ).to_s # make absolute uri
  			dest ="Images/"+File.basename(uri)
  			File.open(dest,'wb'){ |f| f.write(open(uri).read) }
  			arr << dest
  		end
  		p "Downloading successful!"
  		 arr
  	end


  	def create_tables
  		begin
  			user = @con.user
  			db_name = @con.db
  			pswd = @con.pass

  			puts "User: #{user}"
  			puts "Database name: #{db_name}"

  			@con.exec "DROP TABLE IF EXISTS Links"
  			@con.exec "CREATE TABLE Links(id SERIAL PRIMARY KEY, 
  			url text)" 

  			@con.exec "DROP TABLE IF EXISTS Images"
  			@con.exec "CREATE TABLE Images(id SERIAL PRIMARY KEY, link_id INTEGER,
  			url text)" 

  		rescue PG::Error => e
  			puts e.message 
  		end
  	end


  	def save_to_db
  		arr = download_images
  		begin
  			arr.each do | dest |
  			rl = @con.exec "SELECT COUNT (*) FROM links WHERE url='#{@url}'"
  			@con.exec "INSERT INTO links (url) VALUES('#{@url}')" if rl[0]["count"].to_i < 1

  			r_id = @con.exec "SELECT id FROM links WHERE url='#{@url}'"

  			ri = @con.exec "SELECT COUNT (*) FROM images WHERE url='#{dest}'"
  			@con.exec "INSERT INTO Images (link_id,url) VALUES('#{r_id[0]["id"]}','#{dest}')" if ri[0]["count"].to_i < 1
  			
  			end
  			p "Saved to DB!"
  		rescue PG::Error => e
  			puts e.message 
  		end

  	end

  	def fetch_from_db
  		arr = Array.new
  		begin

  			r_id = @con.exec "SELECT id FROM links WHERE url='#{@url}'"

  			ri = @con.exec "SELECT * FROM images WHERE link_id='#{r_id[0]["id"]}'"
  			
  			arr = ri[0]

  		rescue PG::Error => e
  			puts e.message 
  		end

  	end

  end

