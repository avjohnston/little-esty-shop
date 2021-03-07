require 'rails_helper'

RSpec.describe 'Admin invoices index spec' do
  before :each do
    @invoice1, @invoice2, @invoice3 = create_list(:invoice, 3)
    @customer_1 = create(:customer)
    @item_1 = create(:item)
    @item_2 = create(:item)
    @item_3 = create(:item)
    @invoice_item_1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item_1.id, quantity: 2, unit_price: 1.00)
    @invoice_item_2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item_2.id, quantity: 2, unit_price: 5.00)
    @invoice_item_2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item_3.id, quantity: 2, unit_price: 5.00)
    @invoice_2 = create(:invoice, status: :in_progress)
  end

  describe 'as an admin' do
    it 'shows id# of each invoice in the system' do
      visit admin_invoices_path

      within('#all-invoices') do
        expect(page).to have_content(@invoice1.id)
        expect(page).to have_content(@invoice2.id)
        expect(page).to have_content(@invoice3.id)
      end
    end

    it 'ids of invoices are links to their show page' do
      visit admin_invoices_path

      within('#all-invoices') do
        expect(page).to have_link("#{@invoice1.id}")
        expect(page).to have_link("#{@invoice2.id}")
        expect(page).to have_link("#{@invoice3.id}")

        first(:link, "#{@invoice1.id}").click
        expect(current_path).to eq admin_invoice_path(@invoice1)
      end
    end
  end
end
