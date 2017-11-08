class Base

	def self.execute_query(query)
		con = DBConnector.set_connection
		con.exec query
	end

	def self.where (hash)
		query_string = ''
		hash.each do |key, value|
			if query_string == ''
				query_string  << "#{key} = '#{value}'"
			else
				query_string  << "AND '#{key}' = '#{value}'"
			end

		end
		table = "#{self}".tableize
		query = "SELECT * FROM #{table} WHERE #{query_string}"
		puts query
		r = execute_query(query)
		r[0]
	end


	def self.last
		table = "#{self}".tableize
		query = "SELECT * from #{table} order by id desc limit 1"
		puts query
		r = execute_query(query)
		r[0]
	end

	def self.first
		table = "#{self}".tableize
		query = "SELECT * from #{table} order by id asc limit 1"
		puts query
		r = execute_query(query)
		r[0]
	end


end
