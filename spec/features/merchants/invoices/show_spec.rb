require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @customer_1 = create(:customer)
    @customer_2 = create(:customer)

    @item_1 = create(:item, merchant_id: @merchant_1.id, unit_price: 1.00)
    @item_2 = create(:item, merchant_id: @merchant_2.id, unit_price: 1.00)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @invoice_2 = create(:invoice, customer_id: @customer_2.id)

    @invoice_item_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, status: :pending, quantity: 3, unit_price: 2.00)
    @invoice_item_2 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_2.id, status: :packaged, quantity: 2, unit_price: 1.00)
    @invoice_item_3 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id, status: :pending, quantity: 1, unit_price: 1.50)
  end

  describe 'When I visit my merchants invoice show page(/merchants/merchant_id/invoices/invoice_id)' do
    it 'I see information related to that invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.created_at.strftime('%A, %B %d, %Y'))
    end

    it 'I see all of the customer information related to that invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      expect(page).to have_content(@customer_1.full_name)
      expect(page).not_to have_content(@customer_2.full_name)
    end

    it 'I see all of my items on the invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      name = "Name: #{@item_1.name}"
      quantity = "Quantity: #{@invoice_item_1.quantity}"
      unit_price = "Sold For: $#{@invoice_item_1.unit_price_fix}"
      status = "Status: #{@invoice_item_1.status_view_format}"

      expect(page).to have_content(name)
      expect(page).to have_content(quantity)
      expect(page).to have_content(unit_price)
      expect(page).to have_content(status)
    end

    it 'I do not see any information related to Items for other merchants' do
      visit merchant_invoice_path(@merchant_1, @invoice_2)

      name = "Name: #{@item_1.name}"
      quantity = "Quantity: #{@invoice_item_1.quantity}"
      unit_price = "Sold For: $#{@invoice_item_1.unit_price_fix}"
      status = "Status: #{@invoice_item_1.status_view_format}"

      expect(page).not_to have_content(name)
      expect(page).not_to have_content(quantity)
      expect(page).not_to have_content(unit_price)
      expect(page).not_to have_content(status)
    end

    it 'I see the total revenue that will be generated from all of my items on the invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      expect(page).to have_content("#{'%.2f' % @invoice_1.total_revenue}")
    end

    it 'for each item there is a status drop down' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within "#invoice-item-#{@item_1.id}" do
        expect(page).to have_button("Update Item Status")

        select("packaged", from: "status")
        click_on "Update Item Status"
      end

      expect(current_path).to eq(merchant_invoice_path(@merchant_1, @invoice_1))

      within "#invoice-item-#{@item_1.id}" do
        expect(page).to have_content("Status: Packaged")
      end
    end

    it 'current item status is selected by default' do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within "#invoice-item-#{@item_1.id}" do
        expect(page).to have_select('status', selected: 'pending')
      end
    end
  end
end
