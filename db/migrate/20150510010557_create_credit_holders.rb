class CreateCreditHolders < ActiveRecord::Migration
  def change
    create_table :credit_holders do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :address
      t.string :zip_code
      t.integer :credits_total
      t.string :email_address
      t.string :contact_method

      t.timestamps null: false
    end
  end
end
