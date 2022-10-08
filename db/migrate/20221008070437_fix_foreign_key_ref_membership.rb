class FixForeignKeyRefMembership < ActiveRecord::Migration[7.0]
  def change
    remove_reference :memberships, :beerclub, foreign_key: true
    add_reference :memberships, :beer_club
  end
end
