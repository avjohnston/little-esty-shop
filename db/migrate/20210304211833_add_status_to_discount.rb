class AddStatusToDiscount < ActiveRecord::Migration[5.2]
  def change
    add_column :discounts, :status, :integer
  end
end
