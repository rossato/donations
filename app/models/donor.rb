class Donor < ActiveRecord::Base
  include Comparable
  has_many :donations
  belongs_to :user
  
  def <=> (other)
    ret = self.last_name <=> other.last_name
    return ret unless ret == 0
    return self.full_name <=> other.full_name
  end

  def ytd_donations(year = Time.now.year)
    donations.where(date: (Time.new(year)..Time.new(year+1)))
  end

  def ytd_amount(year = Time.now.year)
    ytd_donations(year).select("sum(amount) as ytd_amount").take.ytd_amount
  end

end
