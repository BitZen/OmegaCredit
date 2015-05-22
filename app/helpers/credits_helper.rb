module CreditsHelper
	
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
	
	#called from process_transaction in credits controller
	def cashier(holder_id,owed)
		subtotal = owed
		credits = credits_from_id(holder_id)
		payment = get_oldest(credits)

		if subtotal == 0
			logger.info "TOTAL IS ZERO"
			puts subtotal
		elsif payment.present? != true
			logger.info "NO PAYMENT PRESENT #{owed} IS STILL OWED"
			return owed 
		elsif payment.present? and subtotal >= payment["amount"]
			logger.info "PAYMENT OF #{payment['amount']} IS PRESENT AND LESS THAN OR EQUAL TO THE TOTAL OF #{subtotal}" 
			remainder = subtotal - payment["amount"]
			self.credit_used(payment["id"])
			transaction = Transaction.new do |t|
	          t.event = "use"
	          t.amount_used = subtotal
	          t.amount_remaining = 0
	          t.credit_id = payment["id"]
	          t.credit_holder_id = holder_id
        	end
	        if transaction.save
	          logger.info "New Transaction: #{transaction.attributes.inspect}"
	        else 
	          logger.warn "Transaction did not save"
	        end
			payment = nil
		elsif payment.present? and subtotal < payment["amount"]
			logger.info "THE PAYMENT OF #{payment['amount']} IS PRESENT AND GREATER THAN THE TOTAL OF #{subtotal}"
			change = payment["amount"] - subtotal
			self.credit_balance(payment["id"], change)
			transaction = Transaction.new do |t|
	          t.event = "use"
	          t.amount_used = subtotal
	          t.amount_remaining = change
	          t.credit_id = payment["id"]
	          t.credit_holder_id = holder_id
        	end
	        if transaction.save
	        	logger.info "New Transaction: #{transaction.attributes.inspect}"
	        else 
	          	logger.warn "Transaction did not save"
	        end 
		end

		if remainder
			puts "#{remainder} IS STILL OWED USING NEXT CREDIT"
			self.cashier(holder_id,remainder)
		end
	end

	def credit_balance(credit_id, new_amount)
		Credit.update(credit_id, :amount => new_amount.to_f)
		logger.info "CREDIT BALANCE RUN"
	end

	#builds a array of all a credit holders currently active credits 
	def credits_from_id(id)
		credits_array = []
		credits = CreditHolder.find(id).credits.where(status: 'active')
		credits.each do |c|
			hash = {"id" => c.id, "amount" => c.amount, "created_at" => c.created_at}
			credits_array << hash
		end
		return credits_array
	end

	#given an array, select the oldest credit
	def get_oldest(array)
		oldest = array.sort_by { |c| c["created_at"]}.first
		return oldest
	end	

	#set a credit amount to zero and mark as used
	def credit_used(credit_id)
		Credit.update(credit_id, :amount => 0.00, :status => 'used')
		logger.info "CREDIT USED RUN"
	end

	#update the creditholder.credits_total column with current amount
	def update_credits_total(holder_id)
		credits = []
		CreditHolder.find(holder_id).credits.each do |c|
			credits << c.amount
		end
		CreditHolder.update(holder_id, :credits_total => credits.sum)
	end
end
