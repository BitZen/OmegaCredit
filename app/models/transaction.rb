class Transaction < ActiveRecord::Base
	belongs_to :credit_holder
	belongs_to :credit


	def self.get_transactions(id)
		transactions = Transaction.where(:credit_holder_id => id).order(:created_at => "DESC")
		return transactions
	end

end
