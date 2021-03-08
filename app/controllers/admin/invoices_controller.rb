class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @customer = @invoice.customer
    @items = @invoice.items
    @invoice_statuses = Invoice.statuses.keys
  end

  def update
    @invoice = Invoice.find(params[:id])
    @invoice.update(status: params[:invoice][:status])
    if @invoice.status == 'completed'
      @invoice_items = @invoice.invoice_items
      @invoice_items.map do |ii|
        ii.update(discount_percent: @invoice.discount_percentage(ii.id))
      end
    end

    redirect_to admin_invoice_path(@invoice)
  end
end
