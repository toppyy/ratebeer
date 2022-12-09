class BeerClub < ApplicationRecord
  has_many :applications, -> { where confirmed: false }, class_name: "Membership"
  has_many :applicants, through: :applications, source: :user

  has_many :confirmed_memberships, -> { where confirmed: true }, class_name: "Membership"
  has_many :members, through: :confirmed_memberships, source: :user

  def to_s
    name.to_s
  end
end
