class AddEmailToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :send_email, :integer
  end
end
