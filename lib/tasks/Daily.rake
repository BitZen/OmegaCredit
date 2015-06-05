desc "set status column to expired for all credits past expiration"
task :expire => :environment do
	creds = Credit.where("expires_at <= ? AND status = ?", Time.now, "active")
	Rails.logger.info "Expiring #{creds.count} credits!"
	creds.each do |c|
		c.update(:status => "expired")
		puts c.expires_at
		new_total = CreditHolder.find(c.credit_holder_id).credits_total - c.amount 
		CreditHolder.update(c.credit_holder_id, :credits_total => new_total)
		transaction = Transaction.new do |t|
	          t.event = "expire"
	          t.amount_used = c.amount
	          t.amount_remaining = 0
	          t.credit_id = c.id
	          t.credit_holder_id = c.credit_holder_id
        	end
	        if transaction.save
	          puts "New Transaction: #{transaction.attributes.inspect}"
	        else 
	          puts "Transaction did not save"
	        end
	end
end

desc "create an expired credit"
task :create_expired_credit => :environment do
	Credit.create(:amount => 25, :expires_at => Time.now, :status => "active", :credit_holder_id => 1, :send_email => 1, :num_books => 5)
	new_total = 25 + CreditHolder.find(1).credits_total
	CreditHolder.update(1, :credits_total => new_total)	
end