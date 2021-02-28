require 'rails_helper'

RSpec.describe 'Admin invoices index spec' do
  before :each do
    @invoice1, @invoice2, @invoice3 = create_list(:invoice, 3)
  end

  describe 'as an admin' do
    it 'shows id# of each invoice in the system with link' do
      visit admin_invoices_path

      within('#all-invoices') do
        within("#invoice-#{@invoice1.id}") do
          expect(page).to have_content(@invoice1.id)
          expect(page).to have_link("#{@invoice1.id}")
        end
        within("#invoice-#{@invoice2.id}") do
          expect(page).to have_content(@invoice2.id)
          expect(page).to have_link("#{@invoice2.id}")
        end
        within("#invoice-#{@invoice3.id}") do
          expect(page).to have_content(@invoice3.id)
          expect(page).to have_link("#{@invoice3.id}")
        end
      end
    end

    it 'shows the status of each invoice' do
      visit admin_invoices_path

      within('#all-invoices') do
        within("#invoice-#{@invoice1.id}") do

        expect(page).to have_content(@invoice1.status_view_format)
        end
      end
    end
  end
end
