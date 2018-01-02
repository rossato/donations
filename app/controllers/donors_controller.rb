class DonorsController < ApplicationController
  before_action :set_donor, only: [:show, :edit, :update, :destroy]

  # GET /donors
  # GET /donors.json
  def index
    @donors = Donor.all.order(last_name: :asc)

    respond_to do |format|
      format.html { render }
      format.csv do
        headers['Content-Type'] ||= 'text/csv'
        headers['Content-Disposition'] = 'attachment; filename="donors.csv"'
        render :layout => false
      end
    end
  end
  
  def circles
    donors = Hash.new(0)
    class << donors
      def update_donor(donor)
        circle = 0
        if (donor.total_amount >= 5000)
          circle = 6
        elsif (donor.total_amount >= 2500)
          circle = 5
        elsif (donor.total_amount >= 1000)
          circle = 4
        elsif (donor.total_amount >= 250)
          circle = 3
        elsif (donor.total_amount >= 100)
          circle = 2
        elsif (donor.total_amount >= 25)
          circle = 1
        end
        
        if circle > self[donor]
          self[donor] = circle
        end
      end
    end
    
    start_year = Donation.select(:date).order(date: :asc).take.date.year
    now_year = Time.now.year
    (start_year..now_year).each do |year|
      if (now_year - year > 6)
        minimum_donation = 5000
      elsif (now_year - year > 3)
        minimum_donation = 2500
      elsif (now_year - year > 2)
        minimum_donation = 1000
      elsif (now_year - year > 1)
        minimum_donation = 250
      else
        minimum_donation = 25
      end

      qualifying_donors = Donor.select("donors.id, last_name, full_name, anonymous, sum(amount) as total_amount, #{year} as year").where(:"donations.date" => (Time.new(year)..Time.new(year+1))).group("donors.id").having("sum(amount) >= ?", minimum_donation).joins(:donations)
      qualifying_donors.each {|donor| donors.update_donor(donor)}
    end
    @circles = Array.new(6){[]}
    donors.each do |donor, circle|
      next if circle == 0
      @circles[circle-1] << donor
    end
    @circles.each(&:sort!)
  end

  def unthanked
    @donors =
      Donor.select("donors.id, full_name, solicitation, address, city, state, zip, unthanked_amount, unthanked_qty")
        .from(Donation.select("donor_id, sum(amount) as unthanked_amount, count(*) as unthanked_qty").where(thanked: false).group(:donor_id))
        .joins("INNER JOIN donors on donors.id = donor_id")
      
#      Donation.select(:full_name, :donor_id, :unthanked_amount).from(Donation.select("donor_id, sum(amount) as unthanked_amount").group(:donor_id).where(thanked: false)).joins("INNER JOIN donors ON donors.id = subquery.donor_id")

    respond_to do |format|
      format.html {render}
      format.csv do
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"unthanked.csv\""
        render :layout => false
      end
    end
  end

  def mailing_list
    @donors = Donor.where(do_not_contact: false).order(last_name: :asc)

    respond_to do |format|
      format.html {render}
      format.csv do
        headers['Content-Type'] ||= 'text/csv'
        headers['Content-Disposition'] = 'attachment; filename="mailing_list.csv"'
        render :layout => false
      end
    end
  end
  
  # GET /donors/1
  # GET /donors/1.json
  def show
  end

  # GET /donors/new
  def new
    @donor = Donor.new
  end

  # GET /donors/1/edit
  def edit
  end

  # POST /donors
  # POST /donors.json
  def create
    @donor = Donor.new(donor_params.merge({:user_id => current_user.id}))

    respond_to do |format|
      if @donor.save
        format.html { redirect_to @donor, notice: 'Donor was successfully created.' }
        format.json { render :show, status: :created, location: @donor }
      else
        format.html { render :new }
        format.json { render json: @donor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donors/1
  # PATCH/PUT /donors/1.json
  def update
    respond_to do |format|
      if @donor.update(donor_params.merge({:user_id => current_user.id}))
        format.html { redirect_to @donor, notice: 'Donor was successfully updated.' }
        format.json { render :show, status: :ok, location: @donor }
      else
        format.html { render :edit }
        format.json { render json: @donor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donors/1
  # DELETE /donors/1.json
  def destroy
#    @donor.donations.destroy_all
    @donor.destroy
    respond_to do |format|
      format.html { redirect_to donors_url, notice: 'Donor and donations were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donor
      @donor = Donor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donor_params
      params.require(:donor).permit(:last_name, :full_name, :solicitation, :address, :city, :state, :zip, :phone, :email, :relationship, :singer, :comment, :anonymous, :update_address, :do_not_contact)
    end
end
