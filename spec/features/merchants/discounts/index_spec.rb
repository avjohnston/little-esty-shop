require 'rails_helper'

RSpec.describe 'merchant discounts index page', type: :feature do
  before :each do
    set_up
  end

  it 'merchant dashboard has a link to merchant discount index' do
    visit merchant_dashboard_index_path(@merchant)

    expect(page).to have_link('My Discounts')
    click_link('My Discounts')
    expect(current_path).to eq(merchant_discounts_path(@merchant))
  end

  it 'mercahnt discount index has all merchant discounts and attributes' do
    visit merchant_discounts_path(@merchant)

    expect(page).to have_content("#{@merchant.name}'s Discounts")

    within "#discount-#{@discount_1.id}" do
      expect(page).to have_content("ID: #{@discount_1.id}")
      expect(page).to have_content("Percentage Discount: 20.0%")
      expect(page).to have_content("Quantity Threshold: #{@discount_1.threshold} Items")
    end

    within "#discount-#{@discount_2.id}" do
      expect(page).to have_content("ID: #{@discount_2.id}")
      expect(page).to have_content("Percentage Discount: 10.0%")
      expect(page).to have_content("Quantity Threshold: #{@discount_2.threshold} Items")
    end
  end

  it 'each discount has a link to that merchant discounts show page' do
    visit merchant_discounts_path(@merchant)

    within "#discount-#{@discount_1.id}" do
      expect(page).to have_link("Link To Discount's Show Page")
      click_link("Link To Discount's Show Page")

      expect(current_path).to eq(merchant_discount_path(@merchant, @discount_1))
    end
  end

  it 'merchants discount index page has the next three upcoming holidays' do
    visit merchant_discounts_path(@merchant)

    expect(page).to have_content("Upcoming Holidays")

    within "#holiday-#{@holiday_1.date}" do
      expect(page).to have_content("#{@holiday_1.name}")
      expect(page).to have_content("#{@holiday_1.date}")
    end

    within "#holiday-#{@holiday_2.date}" do
      expect(page).to have_content("#{@holiday_2.name}")
      expect(page).to have_content("#{@holiday_2.date}")
    end

    within "#holiday-#{@holiday_3.date}" do
      expect(page).to have_content("#{@holiday_3.name}")
      expect(page).to have_content("#{@holiday_3.date}")
    end
  end

  it 'merchant discount index has a link to create a new merchant discount' do
    visit merchant_discounts_path(@merchant)

    expect(page).to have_button('Create New Discount')
    click_on('Create New Discount')
    expect(current_path).to eq(new_merchant_discount_path(@merchant))
  end

  it 'each discount has a button to delete the discount' do
    visit merchant_discounts_path(@merchant)

    within "#discount-#{@discount_1.id}" do
      expect(page).to have_button('Delete Discount')
    end

    within "#discount-#{@discount_3.id}" do
      expect(page).to have_button('Delete Discount')
    end
  end

  it 'when i click delete discount it removes the discount from the merchant discount index' do
    visit merchant_discounts_path(@merchant)

    within "#discount-#{@discount_1.id}" do
      click_on('Delete Discount')
    end

    expect(current_path).to eq(merchant_discounts_path(@merchant))

    expect(page).to_not have_content("ID: #{@discount_1.id}")
  end

  it 'a merchant cant delete a discount if there are pending invoice items on it ' do
    visit merchant_discounts_path(@merchant)

    within "#discount-#{@discount_2.id}" do
      expect(page).to_not have_button("Delete Discount")
    end

    within "#discount-#{@discount_1.id}" do
      expect(page).to have_button("Delete Discount")
    end

    within "#discount-#{@discount_3.id}" do
      expect(page).to have_button("Delete Discount")
    end
  end

  def set_up
    @merchant = create(:merchant)
    @discount_1 = @merchant.discounts.create!(percent: 0.20, threshold: 10)
    @discount_2 = @merchant.discounts.create!(percent: 0.10, threshold: 2)
    @discount_3 = @merchant.discounts.create!(percent: 0.15, threshold: 12)

    @holiday_1 = HolidayService.holiday_objects[0]
    @holiday_2 = HolidayService.holiday_objects[1]
    @holiday_3 = HolidayService.holiday_objects[2]

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
