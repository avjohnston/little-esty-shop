class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  validates_presence_of(:percent, :threshold)
  after_initialize :default, unless: :persisted?

  enum status: [:inactive, :active]

  def default
    self.status = 0
  end

  def invoice_items_pending?
    return "edit_delete" if invoice_items.where(status: :pending).where('quantity >= ?', self.threshold).empty?
    "empty"
  end

end
