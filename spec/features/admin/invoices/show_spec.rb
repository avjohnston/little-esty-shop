require 'rails_helper'

RSpec.describe 'Admin invoices show page' do
  before :each do
    setup
  end

  describe 'as an admin' do
    describe'displays invoice information' do
      it 'like id, status, created_at in Day, Month DD, YYYY' do
        visit admin_invoice_path(@invoice_1)

        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content(@invoice_1.status_view_format)
        expect(page).to have_content(@invoice_1.created_at.strftime('%A, %B %d, %Y'))
      end

      it 'displays the total revenue of the invoice' do
        visit admin_invoice_path(@invoice_1)

        expect(page).to have_content("#{'%.2f' % @invoice_1.total_revenue}")
      end
    end

    describe'displays customer information' do
      it 'like full_name and shipping_address' do
        visit admin_invoice_path(@invoice_1)

        within '.admin_invoice#customer_info' do
          expect(page).to have_content(@customer_1.full_name)
        end
      end
    end

    describe'displays invoice_items information' do
      it 'like name, quantity, price, and status' do
        visit admin_invoice_path(@invoice_1)

        within '.admin_invoice#ii_info' do
          expect(page).to have_content(@item_1.name)
          expect(page).to have_content(@item_2.name)
          expect(page).to have_content(@item_3.name)
          expect(page).to have_content(@item_1.status.capitalize)
          expect(page).to have_content(@item_2.status.capitalize)
          expect(page).to have_content(@item_3.status.capitalize)
          expect(page).to have_content(@item_1.unit_price)
          expect(page).to have_content(@item_2.unit_price)
          expect(page).to have_content(@item_3.unit_price)
        end
      end
    end

    describe "you can update an invoice status" do
      it 'has the invoice status as a select field with the current invoice selected' do
        visit admin_invoice_path(@invoice_2)
        # I see the invoice status is a select field
        # And I see that the invoice's current status is selected
        within '#invoice_status_update' do
          expect(page).to have_content(@invoice_2.status)
        end
      end

      it 'can pick a new status for the Invoice and see it updated on the Admin Invoice Show Page' do
        visit admin_invoice_path(@invoice_2)

        select 'completed', from: 'Status'
        click_on('Update Invoice')

        expect(current_path).to eq(admin_invoice_path(@invoice_2))
        expect(page).to have_content("Completed")

        select 'cancelled', from: 'Status'
        click_on('Update Invoice')

        expect(current_path).to eq(admin_invoice_path(@invoice_2))
        expect(page).to have_content("Cancelled")

        select 'in_progress', from: 'Status'
        click_on('Update Invoice')

        expect(current_path).to eq(admin_invoice_path(@invoice_2))
        expect(page).to have_content("In Progress")
      end
    end
  end

  describe 'admin invoice show has discount information' do
    it 'show page has the total revenue after discount display' do
      visit admin_invoice_path(@invoice_1)
      expected = "Total Revenue After Discounts: $#{'%.2f' % @invoice_1.discount_revenue}"

      expect(page).to have_content(expected)
    end

    it 'has a discounted amount for each item with a discount' do
      visit admin_invoice_path(@invoice_1)

      within "#ii-#{@invoice_item_1.id}" do
        expected = "Discount: $#{'%.2f' % @invoice_1.discount_amount(@invoice_item_1.id)}"

        expect(page).to have_content(expected)
      end

      within "#ii-#{@invoice_item_2.id}" do
        expected = "Discount: $#{'%.2f' % @invoice_1.discount_amount(@invoice_item_2.id)}"

        expect(page).to have_content(expected)
      end
    end
  end

  def setup
    @customer_1 = create(:customer)
    @merchant = create(:merchant)
    @discount_1 = @merchant.discounts.create!(percent: 0.1, threshold: 2)
    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @item_1 = create(:item, merchant_id: @merchant.id)
    @item_2 = create(:item, merchant_id: @merchant.id)
    @item_3 = create(:item, merchant_id: @merchant.id)
    @invoice_item_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 2, unit_price: 1.00)
    @invoice_item_2 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 2, unit_price: 5.00)
    @invoice_item_3 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 2, unit_price: 5.00)
    @invoice_2 = create(:invoice, status: :in_progress)
    @invoice_item_4 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 2, unit_price: 1.00)
    @invoice_item_5 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 2, unit_price: 5.00)
    @invoice_item_6 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 2, unit_price: 5.00)
  end
end
