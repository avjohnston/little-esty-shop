require 'rails_helper'

RSpec.describe 'merchants discounts edit page', type: :feature do

  before :each do
    @merchant = create(:merchant)
    @discount_1 = @merchant.discounts.create!(percent: 0.20, threshold: 10, merchant_id: @merchant.id)
  end

  it 'when i visit the discount show page there is a button to edit the discount' do
    visit merchant_discount_path(@merchant, @discount_1)

    expect(page).to have_button('Edit Discount')
  end

  it 'when i click the edit discount button i am taken to the merchant discount edit page' do
    visit merchant_discount_path(@merchant, @discount_1)

    click_on 'Edit Discount'
    expect(current_path).to eq(edit_merchant_discount_path(@merchant, @discount_1))
  end

  it 'the merchant discount edit form has prepopulated values' do
    visit edit_merchant_discount_path(@merchant, @discount_1)

    expect(find_field('percent').value).to eq('0.2')
    expect(find_field('threshold').value).to eq('10')
  end

  it 'when i fill in the fields and click submit it updates the discount on the show page' do
    visit edit_merchant_discount_path(@merchant, @discount_1)

    fill_in 'percent', with: '0.05'
    fill_in 'threshold', with: '5'
    click_on 'Update Discount'

    expect(current_path).to eq(merchant_discount_path(@merchant, @discount_1))

    expect(page).to have_content("#{@merchant.name}'s Discount ##{@discount_1.id}")
    expect(page).to have_content('Discount Percentage: 5.0%')
    expect(page).to have_content('Item Quantity Threshold: 5 Items')
  end

  it 'when i enter invalid fields into the form it doesnt update the discount' do
    visit edit_merchant_discount_path(@merchant, @discount_1)

    fill_in 'percent', with: ''
    fill_in 'threshold', with: ''
    click_on 'Update Discount'

    expect(page).to have_content('Your Discount Was Not Saved')
  end
end
