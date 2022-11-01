class Style < ApplicationRecord
  has_many :beers, dependent: :destroy

  def to_s
    name.to_s
  end
end
