# frozen_string_literal: true

class CreateFavoritePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_places do |t|
      t.references :user, null: false, foreign_key: true
      t.string :place_id

      t.timestamps
    end

    add_index :favorite_places, :place_id
  end
end
