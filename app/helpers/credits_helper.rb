module CreditsHelper
	#TODO: some of this code is out of place(should not be in a helper)
	# 		 refactor and place in more appropriate file.

	#returns array of active credits for a single holder
	def active_credits_array(holder_id)
		credits = []
		holder = CreditHolder.find(holder_id)
		holder.credits.each do |c|
			if c.status == "active"
				credits << c
			end
		end
		return credits
	end

end
