# frozen_string_literal: true
module GoogleSerializer
  class Photo
    include ActiveModel::Serializers::JSON
    attr_accessor :photo_reference

    def initialize(attrs)
      attrs.each do |attr, value|
        send("#{attr}=", value) if respond_to?("#{attr}=")
      end
    end

    def attributes
      {}
    end

    def photo_url
      Google::Maps::Place.photo_url({ photo_reference: photo_reference, maxwidth: 400 })
    end

  end
end
