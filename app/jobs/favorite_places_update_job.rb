class FavoritePlacesUpdateJob < ApplicationJob
  queue_as :low

  def perform(favorite_place)
    # Do something later
    favorite_place.add_data_from_google
  end
end
