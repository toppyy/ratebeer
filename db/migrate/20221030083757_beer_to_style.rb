class BeerToStyle < ActiveRecord::Migration[7.0]
  def change

    change_table :beers do |t|
      t.remove :style
      t.references :style, null: false, foreign_key: true
    end
  end
end
