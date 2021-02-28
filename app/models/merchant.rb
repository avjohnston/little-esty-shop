class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  enum status: { disabled: 0, enabled: 1 }

  def self.by_status(status)
    return [] unless statuses.include?(status)
    where(status: status)
  end

  def self.top_five_by_revenue
    joins(:transactions)
      .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as merchant_revenue')
      .where('transactions.result = ?', Transaction.results[:success])
      .group(:id)
      .order('merchant_revenue desc')
      .limit(5)
  end

  def total_revenue
    revenue_snippet = Arel.sql('sum(invoice_items.unit_price * invoice_items.quantity)')

    transactions.where('transactions.result = ?', Transaction.results[:success])
                .pluck(revenue_snippet)
                .first
  end

  def best_day
    revenue_snippet = Arel.sql('sum(invoice_items.unit_price * invoice_items.quantity)')
    order_by_revenue_snippet = Arel.sql(revenue_snippet + ' desc')

    invoices.select(:created_at, revenue_snippet)
            .joins(:transactions)
            .where('transactions.result = ?', Transaction.results[:success])
            .group(:created_at)
            .order(order_by_revenue_snippet, created_at: :desc)
            .limit(1)
            .pluck(:created_at)
            .first
  end

  def top_five_customers
    customer_ids = invoices.joins(:transactions)
                           .where("transactions.result = ?", Transaction.results[:success])
                           .group(:customer_id)
                           .order(Arel.sql("count(transactions.result = #{Transaction.results[:success]}) desc"))
                           .limit(5)
                           .pluck(:customer_id)

    Customer.find(customer_ids)
  end

  def transaction_count(customer_id)
    transactions.where(result: Transaction.results[:success], invoice_id: Invoice.find_from(customer_id)).size
  end

  def invoice_items_ready
    invoice_items.where.not(status: :shipped)
                            .joins(:invoice)
                            .order('invoices.created_at')
                            .where('invoices.status = 1')
  end

  def item_invoice_date(invoice_id)
    Invoice.find(invoice_id).created_at.strftime('%A, %B %d, %Y')
  end
end
