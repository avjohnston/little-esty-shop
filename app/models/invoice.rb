class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer

  enum status: [:cancelled, :completed, :in_progress]

  def created_at_view_format
    created_at.strftime('%A, %B %d, %Y')
  end

  def self.all_invoices_with_unshipped_items
    joins(:invoice_items)
    .where('invoice_items.status = ?', 1)
    .distinct(:id)
    .order(:created_at)
  end

  def customer_full_name
    customer.full_name
  end

  def total_revenue
    invoice_items.pluck(Arel.sql("sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")).first
  end

  # def discount_data(invoice_item_id)
  #   invoice_items.joins(:discounts)
  #   .where('invoice_items.quantity >= discounts.threshold')
  #   .select('discounts.percent as discount_percent')
  #   .where(id: invoice_item_id)
  #   .order('discounts.percent desc')
  # end

  #
  # def discount_show
  #   discounts = invoice_items.map do |ii|
  #     discount_amount(ii.id)
  #   end.sum
  #
  #   return total_revenue - discounts
  # end

  def discount_find
    invoice_items.joins(:discounts)
                 .where('invoice_items.quantity >= discounts.threshold')
                 .select('invoice_items.*, (invoice_items.quantity * invoice_items.unit_price * discounts.percent) as discount, discounts.id as discount_id, discounts.percent as discount_percent')
                 .order('discounts.percent desc')
  end

  def discount_id(invoice_item_id)
    discount_find.where(id: invoice_item_id).first.discount_id
  end

  def discount_revenue
    discount = discount_find.uniq.sum(&:discount)
    total_revenue - discount
  end

  def discount_amount(invoice_item_id)
    return 0 if discount_find.where(id: invoice_item_id).empty?
    discount_find.where(id: invoice_item_id).first.discount
  end

  def discount_percentage(invoice_item_id)
    return 0 if discount_find.where(id: invoice_item_id).empty?
    discount_find.where(id: invoice_item_id).first.discount_percent
  end

  def gets_discount?(invoice_item_id)
    return 'no_discount' if discount_percentage(invoice_item_id) == 0
    'discount'
  end
end
