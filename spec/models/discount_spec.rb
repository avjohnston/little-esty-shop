require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
  end

  before :each do
    set_up
  end

  describe 'instance methods' do
    it '#no_invoice_items_pending?' do
      expect(@discount_1.invoice_items_pending?).to eq('edit_delete')
      expect(@discount_2.invoice_items_pending?).to eq('empty')
      expect(@discount_3.invoice_items_pending?).to eq('edit_delete')
    end
  end

  def set_up
    @merchant = create(:merchant)
    @discount_1 = @merchant.discounts.create!(percent: 0.20, threshold: 10)
    @discount_2 = @merchant.discounts.create!(percent: 0.10, threshold: 2)
    @discount_3 = @merchant.discounts.create!(percent: 0.15, threshold: 12)

    @customer_1 = create(:customer)
    @item_1 = create(:item, merchant_id: @merchant.id)
    @item_2 = create(:item, merchant_id: @merchant.id)
    @item_3 = create(:item, merchant_id: @merchant.id)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @invoice_item_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 2, unit_price: 1.00, status: :pending)
    @invoice_item_2 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 2, unit_price: 5.00, status: :shipped)
    @invoice_item_3 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 2, unit_price: 5.00, status: :shipped)

    @invoice_2 = create(:invoice, status: :in_progress)
    @invoice_item_4 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 2, unit_price: 1.00, status: :shipped)
    @invoice_item_5 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 2, unit_price: 5.00, status: :shipped)
    @invoice_item_6 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 2, unit_price: 5.00, status: :shipped)
  end
end
