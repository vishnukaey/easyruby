
require 'pg'

class DBConnector
	def self.set_connection
		@con = PG.connect :dbname => 'easyruby', :user => 'postgres', 
		:password => 'qburst'
		@con
	end

	def self.close_connection
		@con.close if @con
	end
end 
