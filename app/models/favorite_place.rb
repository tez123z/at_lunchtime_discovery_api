class FavoritePlace < ApplicationRecord
  
  belongs_to :user
  
  validates_presence_of :place_id
  validates_uniqueness_of :place_id, scope: :user_id

end
