require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationhips' do
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
    it { should belong_to :customer }
  end

  before :each do
    @merchant = create(:merchant)
    @discount_1 = @merchant.discounts.create!(percent: 0.10, threshold: 5)
    @discount_2 = @merchant.discounts.create!(percent: 0.15, threshold: 10)
    @item_1 = create(:item, merchant_id: @merchant.id)
    @item_2 = create(:item, merchant_id: @merchant.id)
    @item_3 = create(:item, merchant_id: @merchant.id)

    @customer_1 = create(:customer, first_name: "Ace")
    @customer_2 = create(:customer, first_name: "Eli")
    @customer_3 = create(:customer)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @invoice_2 = create(:invoice, customer_id: @customer_1.id)
    @invoice_3 = create(:invoice, customer_id: @customer_1.id)
    @transaction_1 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_1.id)
    @transaction_2 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_2.id)
    @ii_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, status: InvoiceItem.statuses[:packaged], quantity: 5, unit_price: 1.00)
    @ii_2 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_2.id, status: InvoiceItem.statuses[:shipped], quantity: 5, unit_price: 2.00)
    @ii_3 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_3.id, status: InvoiceItem.statuses[:shipped], quantity: 5, unit_price: 5.00)
    @ii_4 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_3.id, status: InvoiceItem.statuses[:shipped], quantity: 10, unit_price: 5.00)
    @ii_5 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_3.id, status: InvoiceItem.statuses[:shipped], quantity: 1, unit_price: 5.00)
    #customer_2 related vars
    @invoice_4 = create(:invoice, customer_id: @customer_2.id)
    @invoice_5 = create(:invoice, customer_id: @customer_2.id)
    @invoice_21 = create(:invoice, customer_id: @customer_2.id)
    @invoice_22 = create(:invoice, customer_id: @customer_2.id)
    @transaction_21 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_21.id)
    @transaction_22 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_22.id)
    @ii_21 = create(:invoice_item, invoice_id: @invoice_21.id, status: InvoiceItem.statuses[:packaged])
    #customer_3 related vars
    @invoice_31 = create(:invoice, customer_id: @customer_3.id)
    @invoice_32 = create(:invoice, customer_id: @customer_3.id)
    @transaction_31 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_31.id)
    @transaction_32 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_32.id)
    @ii_31 = create(:invoice_item, invoice_id: @invoice_31.id, status: InvoiceItem.statuses[:shipped])

  end

  describe 'instance methods' do
    describe '#status_view_format' do
      it "cleans up statuses so they are capitalize and have no symbols on view" do
        invoice_a = create(:invoice, status: Invoice.statuses[:cancelled])
        invoice_b = create(:invoice, status: Invoice.statuses[:completed])
        invoice_c = create(:invoice, status: Invoice.statuses[:in_progress])

        expect(invoice_a.status_view_format).to eq("Cancelled")
        expect(invoice_b.status_view_format).to eq("Completed")
        expect(invoice_c.status_view_format).to eq("In Progress")
      end
    end

    describe '#created_at_view_format' do
      it "cleans up statuses so they are capitalize and have no symbols on view" do
        invoice_a = create(:invoice, created_at: Time.new(2021, 2, 24))

        expect(invoice_a.created_at_view_format).to eq("Wednesday, February 24, 2021")
      end
    end

    describe '#customer_full_name' do
      it 'returns customers full name' do
        expect(@invoice_1.customer_full_name).to eq(@customer_1.full_name)
      end
    end

    describe '#total_revenue' do
      it 'returns total revenue from a specific invoice' do
        expect('%.2f' % @invoice_1.total_revenue).to eq('85.00')
      end
    end

    describe '#discount_find' do
      it 'finds the correct discount for an invoices invoice items' do
        expect(@invoice_1.discount_find).to eq([@ii_4, @ii_1, @ii_4, @ii_3])
        expect(@invoice_2.discount_find).to eq([@ii_2])
        expect(@invoice_1.discount_find.first.discount_id).to eq(@discount_2.id)
        expect(@invoice_1.discount_find[1].discount_id).to eq(@discount_1.id)
      end
    end

    describe '#discount_id(invoice_item_id)' do
      it 'should return the correct discount id for a given invoice item' do
        expect(@invoice_1.discount_id(@ii_1.id)).to eq(@discount_1.id)
        expect(@invoice_1.discount_id(@ii_3.id)).to eq(@discount_1.id)
        expect(@invoice_2.discount_id(@ii_2.id)).to eq(@discount_1.id)
        expect(@invoice_1.discount_id(@ii_4.id)).to eq(@discount_2.id)
      end
    end

    describe '#discount_revenue' do
      it 'should return the total revenue after discounts are applied' do
        expect(@invoice_1.discount_revenue).to eq(74.5)
        expect(@invoice_2.discount_revenue).to eq(9)
      end
    end

    describe '#discount_amount(invoice_item_id)' do
      it 'should return the amount that will be discounted for a given invoice item' do
        expect(@invoice_1.discount_amount(@ii_1.id)).to eq(0.5)
        expect(@invoice_1.discount_amount(@ii_3.id)).to eq(2.5)
        expect(@invoice_1.discount_amount(@ii_4.id)).to eq(7.5)
        expect(@invoice_1.discount_amount(@ii_5.id)).to eq(0)
        expect(@invoice_2.discount_amount(@ii_2.id)).to eq(1)
      end
    end
  end

  describe 'class methods' do
    describe '#all_invoices_with_unshipped_items' do
      it 'returns all invoices with unshipped items' do

        expect(Invoice.all_invoices_with_unshipped_items).to eq([@invoice_1, @invoice_21])
      end
    end
  end
end
