json.array!(@credit_holders) do |credit_holder|
  json.extract! credit_holder, :id, :first_name, :last_name, :phone_number, :address, :zip_code, :credits_total, :email_address, :contact_method
  json.url credit_holder_url(credit_holder, format: :json)
end
