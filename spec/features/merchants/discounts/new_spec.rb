require 'rails_helper'

RSpec.describe 'merchant discounts new page', type: :feature do
  before :each do
    @merchant = create(:merchant)
  end
  it 'merchant discounts new page has number fields for percent and threshold' do
    visit new_merchant_discount_path(@merchant)

    expect(page).to have_content("New Discount For #{@merchant.name}")
    fill_in 'percent', with: '0.05'
    fill_in 'threshold', with: '5'

    click_on 'Create Discount'
  end

  it 'if user fills in invalid/no data into the form, it doesnt create the discount' do
    visit new_merchant_discount_path(@merchant)

    click_on 'Create Discount'
    expect(page).to have_content('Your Discount Was Not Saved')
  end

  it 'when i click submit it takes me to merchant discount index and the discount is listed' do
    visit new_merchant_discount_path(@merchant)

    expect(page).to have_content("New Discount For #{@merchant.name}")
    fill_in 'percent', with: '0.05'
    fill_in 'threshold', with: '5'

    click_on 'Create Discount'

    expect(current_path).to eq(merchant_discounts_path(@merchant))
    expect(page).to have_content("Percentage Discount: 5.0%")
    expect(page).to have_content("Quantity Threshold: 5 Items")
  end
end
