class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :discounts, through: :item

  enum status: [:pending, :packaged, :shipped]

  def self.search_for_quantity(invoiceid, itemid)
    select(:quantity)
    .find_by(invoice_id: invoiceid, item_id: itemid)
    .quantity
  end

  def self.find_all_by_invoice(invoice_id)
    where(invoice_id: invoice_id)
  end

  def item_name
    item.name
  end

  def invoice_date
    invoice.created_at_view_format
  end
end
