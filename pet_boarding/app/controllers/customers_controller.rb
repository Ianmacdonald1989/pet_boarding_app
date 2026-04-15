class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    @customers = Customer.order(:last_name, :first_name)
  end

  def show
  end

  def new
    @customer = Customer.new
    @return_to = params[:return_to]
  end

  def edit
    @return_to = params[:return_to]
  end

  def create
    @customer = Customer.new(customer_params)
    return_to = params[:return_to]

    if @customer.save
      redirect_to(return_to.presence || @customer, notice: "Customer created.")
    else
      @return_to = return_to
      render :new, status: :unprocessable_entity
    end
  end

  def update
    return_to = params[:return_to]

    if @customer.update(customer_params)
      redirect_to(return_to.presence || @customer, notice: "Customer updated.")
    else
      @return_to = return_to
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, status: :see_other, notice: "Customer deleted."
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone)
  end
end

