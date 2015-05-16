class ChangeCreditsTotal < ActiveRecord::Migration
  def change
  	remove_column :credit_holders, :credits_total
  	add_column :credit_holders, :credits_total, :float, default: 0
  end
end
