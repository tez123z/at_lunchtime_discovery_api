# frozen_string_literal: true

class FavoritePlaceSweeper < ActionController::Caching::Sweeper
  observe FavoritePlace # This sweeper is going to keep an eye on the FavoritePlace model

  # If our sweeper detects that a FavoritePlace was created call this
  def after_create(favorite_place)
    expire_cache_for(favorite_place)
  end

  # If our sweeper detects that a FavoritePlace was updated call this
  def after_update(favorite_place)
    expire_cache_for(favorite_place)
  end

  # If our sweeper detects that a FavoritePlace was deleted call this
  def after_destroy(favorite_place)
    expire_cache_for(favorite_place)
  end

  private

  def expire_cache_for(_product)
    # Expire the search page now that we added a new FavoritePlace
    expire_page(controller: 'google_places', action: 'search')
  end
end
