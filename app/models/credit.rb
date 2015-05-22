class Credit < ActiveRecord::Base
	has_many :transactions
	belongs_to :credit_holder

	
end
