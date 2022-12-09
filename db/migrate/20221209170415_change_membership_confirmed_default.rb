class ChangeMembershipConfirmedDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :memberships, :confirmed, from: nil, to: false
  end
end
