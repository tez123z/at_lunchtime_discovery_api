class AddDataToFavoritePlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :favorite_places, :data, :jsonb
  end
end
