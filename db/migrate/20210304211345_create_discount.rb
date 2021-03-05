class CreateDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.decimal :percent
      t.integer :threshold
    end
  end
end
