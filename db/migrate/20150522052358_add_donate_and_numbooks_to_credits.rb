class AddDonateAndNumbooksToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :donate, :integer
    add_column :credits, :num_books, :integer
  end
end
