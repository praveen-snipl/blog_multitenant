class Tenant < ActiveRecord::Base
	after_create :create_schema

	def create_schema
		self.class.connection.execute("create schema tenant_#{id}")

		scope_schema do
			load Rails.root.join("db/schema.rb")
			self.class.connection.execute("drop table #{self.class.table_name}")
		end
	end

	def scope_schema(*paths)
		# raise paths.to_s
		original_search_path = self.class.connection.schema_search_path
		if(domain != self.class.connection.current_database)
			self.class.connection.schema_search_path = ["tenant_#{id}", *paths].join(",")
		end
		yield 
	ensure
		self.class.connection.schema_search_path = original_search_path
	end

end
