class DonationsController < ApplicationController
  before_action :set_donation, only: [:show, :edit, :update]

  # GET /donations
  # GET /donations.json
  def index
    if (donor_id = params[:donor_id] and @donor = Donor.find(donor_id))
      @donations = @donor.donations.order(date: :asc)
    else
      @donations = Donation.all.order(date: :asc)
    end
    filter_by_year

    respond_to do |format|
      format.html { render }
      format.csv do
        headers['Content-Type'] ||= 'text/csv'
        headers['Content-Disposition'] = 'attachment; filename="donations.csv"'
        render :layout => false
      end
    end
  end

  # GET /donations/1
  # GET /donations/1.json
  def show
  end

  # GET /donations/new
  def new
    @donor = Donor.find(params[:donor_id])
    @donation = @donor.donations.new
  end

  def by_singer
    @donations = Donation.select("singer, donations.id, donor_id, full_name, date, amount").joins(:donor).where(match: false).order("donors.singer ASC, donations.date ASC")
    filter_by_year
  end
  
  # GET /donations/1/edit
  def edit
  end

  # POST /donations
  # POST /donations.json
  def create
    @donor = Donor.find(params[:donor_id])
    @donation = @donor.donations.create(donation_params.merge({:user_id => current_user.id}))

    respond_to do |format|
      if @donation.save
        format.html { redirect_to @donor, notice: 'Donation was successfully created.' }
        format.json { render :show, status: :created, location: [@donor, @donation] }
      else
        format.html { render :new }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donations/1
  # PATCH/PUT /donations/1.json
  def update
    respond_to do |format|
      if @donation.update(donation_params.merge({:user_id => current_user.id}))
        format.html { redirect_to [@donor,@donation], notice: 'Donation was successfully updated.' }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donations/1
  # DELETE /donations/1.json
  def destroy
    donation = Donation.find(params[:id])
    donor = donation.donor
    donation.destroy
    respond_to do |format|
      format.html {
        if donor
          redirect_to donor_url(donor), notice: 'Donation was successfully destroyed.'
        else
          redirect_to donations_url, notice: 'Donation was successfully destroyed.'
        end
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.find(params[:id])
      @donor = @donation.donor
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donation_params
      params.require(:donation).permit(:donor_id, :amount, :date, :comment, :thanked, :match)
    end

    def filter_by_year
      if params[:year]
        @year = params[:year].to_i
        @donations = @donations.where(:"donations.date" => Time.new(@year)..Time.new(@year+1))
      end
    end
end
