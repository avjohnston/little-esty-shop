class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
    # @next_holidays = HolidayService.holiday_objects
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.create(discount_params)
    if @discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = "Your Discount Was Not Saved"
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash[:error] = "Your Discount Was Not Saved"
      render :edit
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
    Discount.destroy(@discount.id)
    redirect_to merchant_discounts_path(@merchant)
  end

  private
  def discount_params
    params.permit(:percent, :threshold)
  end
end
