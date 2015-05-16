class Change < ActiveRecord::Migration
  def change
  	remove_column :credits, :amount
  	add_column :credits, :amount, :float, default: 0
  end
end
