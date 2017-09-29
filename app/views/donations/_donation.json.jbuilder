json.extract! donation, :id, :donor_id, :amount, :date, :comment, :thanked, :match, :created_at, :updated_at
json.url donation_url(donation, format: :json)
