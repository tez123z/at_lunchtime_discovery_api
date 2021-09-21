require "rails_helper"

RSpec.describe FavoritePlacesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/favorite_places").to route_to("favorite_places#index")
    end

    it "routes to #show" do
      expect(get: "/favorite_places/1").to route_to("favorite_places#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/favorite_places").to route_to("favorite_places#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/favorite_places/1").to route_to("favorite_places#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/favorite_places/1").to route_to("favorite_places#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/favorite_places/1").to route_to("favorite_places#destroy", id: "1")
    end
  end
end
