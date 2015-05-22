class AddCreditIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :credit_id, :integer
  end
end
