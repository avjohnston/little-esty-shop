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
      @invoice.invoice_item_update
    end

    redirect_to admin_invoice_path(@invoice)
  end
end
