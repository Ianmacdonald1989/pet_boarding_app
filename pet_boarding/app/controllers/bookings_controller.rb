class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]
  before_action :set_customers, only: %i[new edit create update]

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.includes(:customer, :pets).order(start_date: :desc)
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  def invoice
    @booking = Booking.includes(:customer, :pets, :booking_extras).find(params[:id])
    render layout: "invoice"
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @booking.pets.build
    @booking.booking_extras.build
  end

  # GET /bookings/1/edit
  def edit
    @booking.pets.build if @booking.pets.empty?
    @booking.booking_extras.build if @booking.booking_extras.empty?
  end

  # POST /bookings or /bookings.json
  def create
    @booking = Booking.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: "Booking was successfully created." }
        format.json { render :show, status: :created, location: @booking }
      else
        # If validation fails with no nested pets, show at least one pet row.
        @booking.pets.build if @booking.pets.empty?
        @booking.booking_extras.build if @booking.booking_extras.empty?
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: "Booking was successfully updated." }
        format.json { render :show, status: :ok, location: @booking }
      else
        @booking.pets.build if @booking.pets.empty?
        @booking.booking_extras.build if @booking.booking_extras.empty?
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_path, status: :see_other, notice: "Booking was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(
        :customer_id,
        :start_date,
        :end_date,
        pets_attributes: %i[id pet_type pet_size quantity _destroy],
        booking_extras_attributes: %i[id description quantity unit_price_cents _destroy]
      )
    end

    def set_customers
      @customers = Customer.order(:last_name, :first_name)
    end
end
