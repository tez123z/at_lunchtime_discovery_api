module GoogleSerializer
  class Photos
    def self.add_urls(place, maxwidth = 400)
      return unless place["photos"] && place["photos"].kind_of?(Array)
       place["photos"].each do |p| 
        p["photo_url"] = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{maxwidth}"\
        "&photo_reference=#{p["photo_reference"]}&key=#{GOOGLE_API_KEY}" if p["photo_reference"] 
      end
    end
  end
end
  