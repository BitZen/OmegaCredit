json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :type, :credit_holder_id, :amount, :donate, :num_books, :amount_used, :amount_remaining
  json.url transaction_url(transaction, format: :json)
end
