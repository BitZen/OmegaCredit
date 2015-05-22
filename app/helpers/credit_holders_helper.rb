module CreditHoldersHelper
	def donate(transaction)
		if transaction.donate == 1
			return "yes"
		elsif transaction.donate == 0
			return "no"
		else 
			return "-"
		end
	end
end
