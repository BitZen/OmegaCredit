class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :amount
      t.datetime :expires_at
      t.string :status
      t.integer :credit_holder_id

      t.timestamps null: false
    end
  end
end
