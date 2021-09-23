# frozen_string_literal: true

module GoogleSerializer
  class Photos
    def self.add_urls(place, maxwidth = 400)
      return unless place['photos'].is_a?(Array)
      place['photos'].each do |p|
        if p['photo_reference']
          p['photo_url']= Google::Maps::Place.photo_url({photo_reference:p['photo_reference'],maxwidth:maxwidth})
        end
      end
    end
  end
end
