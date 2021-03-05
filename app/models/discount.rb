class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of(:percent, :threshold)
  after_initialize :default, unless: :persisted?

  enum status: [:inactive, :active]
  
  def default
    self.status = 0
  end
end
