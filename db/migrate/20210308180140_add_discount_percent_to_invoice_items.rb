class AddDiscountPercentToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :discount_percent, :decimal
  end
end
