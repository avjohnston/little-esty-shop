require 'rails_helper'

RSpec.describe Item do
  describe 'relationhips' do
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :merchant }
  end

  before :each do
    setup_data
  end

  describe 'class methods' do
    describe '::enabled' do
      it 'returns enabled items' do
        expected = [@item]

        expect(Item.enabled).to eq(expected)
      end
    end

    describe '::disabled' do
      it 'returns disabled items' do
        expected = [@item2, @item3, @item4, @item5, @item6, @item7]

        expect(Item.disabled).to eq(expected)
      end
    end

    describe "::max_id" do
      it 'returns max id plus 1' do
        expect(Item.max_id).to eq(Item.maximum(:id) + 1)
      end
    end

    describe '::top_five' do
      it 'returns the top five items for a merchant in terms of total_revenue' do
        expect(Item.top_five).to eq([@item, @item7])
      end

      it 'returns total revenue for a merchants top five items' do
        expect(Item.top_five.first.total_revenue.to_f.round(2)).to eq(375.0)
      end
    end
  end

  describe 'instance methods' do
    describe '#best_day' do
      it 'returns the best day for a given item' do
        expect(@item.best_day).to eq(sample_date.strftime('%m/%d/%Y'))
      end

      it 'edge case for items best day with same total revenue' do
        expect(@item7.best_day).to eq(@invoice_61.created_at.strftime('%m/%d/%Y'))
      end
    end

    describe '#invoice_item(invoice_id)' do
      it 'returns the id of an items invoice item' do
        expect(@item.invoice_item(@invoice_1.id)).to eq(@invoice_item_1.id)
      end
    end
  end

  def sample_date
    DateTime.new(2021, 01, 01)
  end

  def setup_data
    @merchant = create(:merchant)

    @item = create(:item, merchant_id: @merchant.id, status: :enabled)
    @item2 = create(:item, merchant_id: @merchant.id)
    @item3 = create(:item, merchant_id: @merchant.id)
    @item4 = create(:item, merchant_id: @merchant.id)
    @item5 = create(:item, merchant_id: @merchant.id)
    @item6 = create(:item, merchant_id: @merchant.id)
    @item7 = create(:item, merchant_id: @merchant.id)

    @customer_1 = create(:customer, first_name: "Ace")
    @invoice_1 = create(:invoice, customer_id: @customer_1.id, status: :completed, created_at: sample_date)
    @invoice_2 = create(:invoice, customer_id: @customer_1.id, created_at: sample_date)
    @invoice_3 = create(:invoice, customer_id: @customer_1.id, created_at: sample_date)
    @invoice_4 = create(:invoice, customer_id: @customer_1.id, created_at: sample_date)
    @invoice_5 = create(:invoice, customer_id: @customer_1.id, created_at: sample_date)
    @invoice_6 = create(:invoice, customer_id: @customer_1.id, created_at: sample_date)

    @invoice_item_1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id, status: :pending, quantity: 5, unit_price: 5)
    @invoice_item_2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id, quantity: 5, unit_price: 5)
    @invoice_item_3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id, quantity: 5, unit_price: 5)
    @invoice_item_4 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id, quantity: 5, unit_price: 5)
    @invoice_item_5 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_5.id, quantity: 5, unit_price: 5, status: :shipped)
    @invoice_item_6 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice_6.id, status: :shipped, quantity: 5, unit_price: 5)

    @transaction_1 = create(:transaction, result: 1, invoice_id: @invoice_1.id)
    @transaction_2 = create(:transaction, result: 1, invoice_id: @invoice_2.id)
    @transaction_3 = create(:transaction, result: 1, invoice_id: @invoice_3.id)
    @transaction_4 = create(:transaction, result: 1, invoice_id: @invoice_4.id)
    @transaction_5 = create(:transaction, result: 1, invoice_id: @invoice_5.id)

    @customer_2 = create(:customer, first_name: "Eli")
    @invoice_21 = create(:invoice, customer_id: @customer_2.id, created_at: sample_date)
    @invoice_22 = create(:invoice, customer_id: @customer_2.id, created_at: sample_date)
    @invoice_23 = create(:invoice, customer_id: @customer_2.id, created_at: sample_date)
    @invoice_24 = create(:invoice, customer_id: @customer_2.id, created_at: sample_date)
    @invoice_25 = create(:invoice, customer_id: @customer_2.id, created_at: sample_date)

    @invoice_item_21 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_21.id, quantity: 5, unit_price: 5)
    @invoice_item_22 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_22.id, quantity: 5, unit_price: 5)
    @invoice_item_23 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_23.id, quantity: 5, unit_price: 5)
    @invoice_item_24 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_24.id, quantity: 5, unit_price: 5)
    @invoice_item_25 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_25.id, quantity: 5, unit_price: 5)

    @transaction_21 = create(:transaction, result: 0, invoice_id: @invoice_21.id)
    @transaction_22 = create(:transaction, result: 0, invoice_id: @invoice_22.id)
    @transaction_23 = create(:transaction, result: 0, invoice_id: @invoice_23.id)
    @transaction_24 = create(:transaction, result: 1, invoice_id: @invoice_24.id)
    @transaction_25 = create(:transaction, result: 0, invoice_id: @invoice_25.id)

    @customer_3 = create(:customer, first_name: "Danny")
    @invoice_31 = create(:invoice, customer_id: @customer_3.id, created_at: sample_date)
    @invoice_32 = create(:invoice, customer_id: @customer_3.id, created_at: sample_date)
    @invoice_33 = create(:invoice, customer_id: @customer_3.id, created_at: sample_date)
    @invoice_34 = create(:invoice, customer_id: @customer_3.id, created_at: sample_date)
    @invoice_35 = create(:invoice, customer_id: @customer_3.id, created_at: sample_date)

    @invoice_item_31 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_31.id, quantity: 5, unit_price: 5)
    @invoice_item_32 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_32.id, quantity: 5, unit_price: 5)
    @invoice_item_33 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_33.id, quantity: 5, unit_price: 5)
    @invoice_item_34 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_34.id, quantity: 5, unit_price: 5)
    @invoice_item_35 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_35.id, quantity: 5, unit_price: 5)

    @transaction_31 = create(:transaction, result: 0, invoice_id: @invoice_31.id)
    @transaction_32 = create(:transaction, result: 1, invoice_id: @invoice_32.id)
    @transaction_33 = create(:transaction, result: 1, invoice_id: @invoice_33.id)
    @transaction_34 = create(:transaction, result: 0, invoice_id: @invoice_34.id)
    @transaction_35 = create(:transaction, result: 0, invoice_id: @invoice_35.id)

    @customer_4 = create(:customer, first_name: "Cate")
    @invoice_41 = create(:invoice, customer_id: @customer_4.id, created_at: sample_date)
    @invoice_42 = create(:invoice, customer_id: @customer_4.id, created_at: sample_date)
    @invoice_43 = create(:invoice, customer_id: @customer_4.id, created_at: sample_date)
    @invoice_44 = create(:invoice, customer_id: @customer_4.id, created_at: sample_date)
    @invoice_45 = create(:invoice, customer_id: @customer_4.id, created_at: sample_date)

    @invoice_item_41 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_41.id, quantity: 5, unit_price: 5)
    @invoice_item_42 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_42.id, quantity: 5, unit_price: 5)
    @invoice_item_43 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_43.id, quantity: 5, unit_price: 5)
    @invoice_item_44 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_44.id, quantity: 5, unit_price: 5)
    @invoice_item_45 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_45.id, quantity: 5, unit_price: 5)

    @transaction_41 = create(:transaction, result: 1, invoice_id: @invoice_41.id)
    @transaction_42 = create(:transaction, result: 1, invoice_id: @invoice_42.id)
    @transaction_43 = create(:transaction, result: 1, invoice_id: @invoice_43.id)
    @transaction_44 = create(:transaction, result: 0, invoice_id: @invoice_44.id)
    @transaction_45 = create(:transaction, result: 0, invoice_id: @invoice_45.id)

    @customer_5 = create(:customer, first_name: "Bob")
    @invoice_51 = create(:invoice, customer_id: @customer_5.id, created_at: sample_date)
    @invoice_52 = create(:invoice, customer_id: @customer_5.id, created_at: sample_date)
    @invoice_53 = create(:invoice, customer_id: @customer_5.id, created_at: sample_date)
    @invoice_54 = create(:invoice, customer_id: @customer_5.id, created_at: sample_date)
    @invoice_55 = create(:invoice, customer_id: @customer_5.id, created_at: sample_date)

    @invoice_item_51 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_51.id, quantity: 5, unit_price: 5)
    @invoice_item_52 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_52.id, quantity: 5, unit_price: 5)
    @invoice_item_53 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_53.id, quantity: 5, unit_price: 5)
    @invoice_item_54 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_54.id, quantity: 5, unit_price: 5)
    @invoice_item_55 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_55.id, quantity: 5, unit_price: 5)

    @transaction_51 = create(:transaction, result: 1, invoice_id: @invoice_51.id)
    @transaction_52 = create(:transaction, result: 1, invoice_id: @invoice_52.id)
    @transaction_53 = create(:transaction, result: 1, invoice_id: @invoice_53.id)
    @transaction_54 = create(:transaction, result: 1, invoice_id: @invoice_54.id)
    @transaction_55 = create(:transaction, result: 0, invoice_id: @invoice_55.id)

    @customer_6 = create(:customer)
    @customer_7 = create(:customer)
    @customer_8 = create(:customer)
    @customer_9 = create(:customer)
    @customer_10 = create(:customer)

    @customer_11 = create(:customer, first_name: "Zen")

    @invoice_61 = create(:invoice, customer_id: @customer_11.id, created_at: '2020-02-01')
    @invoice_62 = create(:invoice, customer_id: @customer_11.id, created_at: '2020-01-01')
    @invoice_63 = create(:invoice, customer_id: @customer_11.id, created_at: '2020-02-15')

    @invoice_item_61 = create(:invoice_item, item_id: @item7.id, invoice_id: @invoice_61.id, quantity: 5, unit_price: 5.00)
    @invoice_item_62 = create(:invoice_item, item_id: @item7.id, invoice_id: @invoice_62.id, quantity: 5, unit_price: 5.00)
    @invoice_item_63 = create(:invoice_item, item_id: @item7.id, invoice_id: @invoice_63.id, quantity: 5, unit_price: 1.00)

    @transaction_61 = create(:transaction, result: 1, invoice_id: @invoice_61.id)
    @transaction_62 = create(:transaction, result: 1, invoice_id: @invoice_62.id)
    @transaction_63 = create(:transaction, result: 1, invoice_id: @invoice_63.id)
  end
end
