module TransactionsHelper
	
	def body_class(class_name="default_class")
	    content_for :body_class, class_name
	end

	def weekly_array(event)
		array = []
		$i = 0
		until $i == 7
			array << Transaction.get_sum(Transaction.date_range(event, Date.today.beginning_of_week.beginning_of_day + $i.days,Date.today.beginning_of_week.end_of_day + $i.days),event)
			$i+= 1
		end
		return array 
	end

	def monthly_array(event)
		array = []
		days = Time.days_in_month(Date.today.month,Date.today.year)
		$i = 0
		until $i == days
			array << Transaction.get_sum(Transaction.date_range(event, Date.today.at_beginning_of_month.beginning_of_day + $i.days, Date.today.at_beginning_of_month.end_of_day + $i.days), event)
			$i+= 1
		end
		return array
	end

	def month_label
		array = []
		days = Time.days_in_month(Date.today.month,Date.today.year)
		$i = 1
		until $i == (days + 1)
			array << $i
			$i += 1
		end
		return array
	end

	def credit_info(time_period,format_type,credit_type)
		d = Date.today
		now = DateTime.now
        if credit_type == "create"
        	if time_period == "today"
        		todays_created = Transaction.date_range("create",d.beginning_of_day,now)
        		if format_type == "count"
        			todays_created.count
        		elsif format_type == "amount"
        			number_to_currency(Transaction.get_sum(todays_created,"create"))
        		end
        	elsif time_period == "weekly"
        		weekly_created = Transaction.date_range("create",d.beginning_of_week,now)
        		if format_type == "count"
        			weekly_created.count
        		elsif format_type == "amount"
        			number_to_currency(Transaction.get_sum(weekly_created,"create"))
        		end
        	elsif time_period == "monthly"
        		monthly_created = Transaction.date_range("create",d.beginning_of_month, now)
        		if format_type == "count"
        			monthly_created.count
        		elsif format_type == "amount"
        			number_to_currency(Transaction.get_sum(monthly_created,"create"))
        		end
        	end
        elsif credit_type == "use"
        	if time_period == "today"
        		daily_used = Transaction.date_range("use",d.beginning_of_day,now)
        		if format_type == "count"
        			daily_used.count
        		elsif format_type == "amount"
        			number_to_currency(Transaction.get_sum(daily_used,"use"))
        		end
        	elsif time_period == "weekly"
        		weekly_used = Transaction.date_range("use",d.at_beginning_of_week, now)
        		if format_type == "count"
        			weekly_used.count
        		elsif format_type == "amount"
        			number_to_currency(Transaction.get_sum(weekly_used,"use"))
        		end
        	elsif time_period == "monthly"
        		monthly_used = Transaction.date_range("use",d.beginning_of_month, now)
        		if format_type == "count"
        			monthly_used.count
        		elsif format_type == "amount"
        			number_to_currency(Transaction.get_sum(monthly_used,"use"))
        		end
        	end
        end
	end

end
