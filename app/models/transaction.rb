class Transaction < ActiveRecord::Base
	belongs_to :credit_holder
	belongs_to :credit


	def self.get_transactions(id)
		transactions = Transaction.where(:credit_holder_id => id).order(:created_at => "DESC")
		return transactions
	end

	def self.date_range(type,start,stop)
		if type == "create"
		transactions = Transaction.where(:created_at => start..stop, :event => "create")
		elsif type == "use"
		transactions = Transaction.where(:created_at => start..stop, :event => "use")
		end	
		return transactions
	end

	def self.get_sum(credits, type)
		if credits.count == 0 
			return 0
		else 
			if type == "create"
				a =[]
				credits.each do |c|
					a << c.amount
				end 
				sum = a.inject(:+)
				return sum
			elsif type == "use"
				a =[]
				credits.each do |c|
					a << c.amount_used
				end 
				sum = a.inject(:+)
				return sum
			end	 
		end
	end
end
