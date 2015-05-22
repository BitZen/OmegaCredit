class CreditHolder < ActiveRecord::Base
	has_many :credits
	has_many :transactions 

	def self.search(search)
		if search
			where('first_name LIKE ? OR last_name LIKE ? OR phone_number LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
		else 
			all
		end 
	end

end
