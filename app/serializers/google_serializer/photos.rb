# frozen_string_literal: true

module GoogleSerializer
  class Photos
    def self.add_urls(place, maxwidth = 400)
      return unless place['photos'].is_a?(Array)

      place['photos'].each do |p|
        if p['photo_reference']
          p['photo_url'] = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{maxwidth}"\
                           "&photo_reference=#{p['photo_reference']}&key=#{GOOGLE_API_KEY}"
        end
      end
    end
  end
end
