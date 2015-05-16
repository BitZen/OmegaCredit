module CreditsHelper
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

	def credit_balance(credit_id, new_amount)
		Credit.update(credit_id, :amount => new_amount.to_f)
	end

	def credit_used(credit_id)
		Credit.update(credit_id, :amount => 0.00, :status => 'used')
	end

	def update_credits_total(holder_id)
		credits = []
		CreditHolder.find(holder_id).credits.each do |c|
			credits << c.amount
		end
		CreditHolder.update(holder_id, :credits_total => credits.sum)
	end
end
