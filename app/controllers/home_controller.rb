class HomeController < ApplicationController
  def index
    @ytd_total = Donation.select("sum(amount) as total_amount").where(date: (Time.new(Time.now.year)..Time.new(Time.now.year+1))).take.total_amount
    @last_ytd_total = Donation.select("sum(amount) as total_amount").where(date: (Time.new(Time.now.year-1)..Time.new(Time.now.year))).take.total_amount
  end
end
