class AddEventToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :event, :string
    remove_column :transactions, :type
  end
end
