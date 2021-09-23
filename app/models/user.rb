# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: DenyList

  has_many :favorite_places, dependent: :destroy
  has_many :favorite_places_with_data, -> { where.not(data: nil) }, class_name: 'FavoritePlace', inverse_of: :user
end
