require 'rails_helper'

RSpec.describe 'merchant discount show page', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @discount_1 = @merchant.discounts.create!(percent: 0.20, threshold: 10, merchant_id: @merchant.id)
    @discount_2 = @merchant.discounts.create!(percent: 0.10, threshold: 15, merchant_id: @merchant.id)
    @discount_3 = @merchant.discounts.create!(percent: 0.15, threshold: 12, merchant_id: @merchant.id)
  end

  it 'when i visit my merchant discount show page' do
    visit merchant_discount_path(@merchant, @discount_1)

    expect(page).to have_content("#{@merchant.name}'s Discount ##{@discount_1.id}")
    expect(page).to have_content("Discount Percentage: 20.0%")
    expect(page).to have_content("Item Quantity Threshold: #{@discount_1.threshold}")
  end
end
