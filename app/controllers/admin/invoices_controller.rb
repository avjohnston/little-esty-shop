class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @customer = @invoice.customer
    @items = @invoice.items
  end

  def update
    Invoice.update(params[:invoices].keys, params[:invoices].values)
    redirect_to admin_invoices_path
  end
end
