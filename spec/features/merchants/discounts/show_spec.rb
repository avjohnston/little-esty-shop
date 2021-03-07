require 'rails_helper'

RSpec.describe 'merchant discount show page', type: :feature do
  before :each do
    set_up
  end

  it 'when i visit my merchant discount show page' do
    visit merchant_discount_path(@merchant, @discount_1)

    expect(page).to have_content("#{@merchant.name}'s Discount ##{@discount_1.id}")
    expect(page).to have_content("Discount Percentage: 20.0%")
    expect(page).to have_content("Item Quantity Threshold: #{@discount_1.threshold}")
  end

  it 'merchants discount show only has button to delete/update if there are no pending invoice items that have that discount' do
    visit merchant_discount_path(@merchant, @discount_1)
    expect(page).to have_button("Edit Discount")

    visit merchant_discount_path(@merchant, @discount_3)
    expect(page).to have_button("Edit Discount")

    visit merchant_discount_path(@merchant, @discount_2)
    expect(page).to_not have_button("Edit Discount")
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
