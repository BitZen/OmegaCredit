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

	#update the creditholder.credits_total column with current amount
	def self.update_credits_total(holder_id)
		credits = []
		CreditHolder.find(holder_id).credits.each do |c|
			credits << c.amount
		end
		CreditHolder.update(holder_id, :credits_total => credits.sum)
	end

end
