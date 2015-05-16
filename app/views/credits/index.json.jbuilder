json.array!(@credits) do |credit|
  json.extract! credit, :id, :amount, :expires_at, :status, :credit_holder_id
  json.url credit_url(credit, format: :json)
end
