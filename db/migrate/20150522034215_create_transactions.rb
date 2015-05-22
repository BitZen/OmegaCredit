class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :type
      t.integer :credit_holder_id
      t.float :amount
      t.integer :donate
      t.integer :num_books
      t.float :amount_used
      t.float :amount_remaining

      t.timestamps null: false
    end
  end
end
