class Credit < ActiveRecord::Base
	has_many :transactions
	belongs_to :credit_holder

	#builds a array of all a credit holders currently active credits
	def self.credits_from_id(id)
		credits_array = []
		credits = CreditHolder.find(id).credits.where(status: 'active')
		credits.each do |c|
			hash = {"id" => c.id, "amount" => c.amount, "created_at" => c.created_at}
			credits_array << hash
		end
		return credits_array
	end

	#set a credit amount to zero and mark as used
	def self.credit_used(credit_id)
		Credit.update(credit_id, :amount => 0.00, :status => 'used')
		logger.info "CREDIT USED RUN"
	end

	def self.credit_balance(credit_id, new_amount)
		Credit.update(credit_id, :amount => new_amount.to_f)
		logger.info "CREDIT ID:#{credit_id} NEW BALANCE: #{new_amount}"
	end
	
end
