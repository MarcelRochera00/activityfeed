class GpxParser
  def self.parse(file_path)
    doc = Nokogiri::XML(File.read(file_path))
    points = doc.css("trkpt").map do |pt|
      {
        lat: pt["lat"].to_f,
        lng: pt["lon"].to_f,
        ele: pt.at_css("ele")&.text.to_f,
        time: pt.at_css("time")&.text
      }
    end

    name = doc.at_css("trk name")&.text || doc.at_css("metadata name")&.text

    # Calculate distance and elevation
    distance = 0.0
    elevation_gain = 0.0

    points.each_cons(2) do |p1, p2|
      distance += haversine(p1[:lat], p1[:lng], p2[:lat], p2[:lng])

      if p1[:ele] && p2[:ele] && p2[:ele] > p1[:ele]
        elevation_gain += (p2[:ele] - p1[:ele])
      end
    end

    # Calculate duration
    duration_str = nil
    if points.any? && points.first[:time] && points.last[:time]
      start_time = Time.parse(points.first[:time]) rescue nil
      end_time = Time.parse(points.last[:time]) rescue nil
      if start_time && end_time && end_time > start_time
        total_seconds = end_time - start_time
        hours = (total_seconds / 3600).to_i
        minutes = ((total_seconds % 3600) / 60).to_i
        duration_str = "#{hours}h #{minutes}m"
      end
    end

    {
      trail_name: name,
      distance_km: distance.round(1),
      elevation_gain: elevation_gain.round(0),
      duration: duration_str,
      points: points
    }
  end

  private

  def self.haversine(lat1, lon1, lat2, lon2)
    rad_per_deg = Math::PI / 180
    r_km = 6371 # Earth radius in kilometers

    dlat_rad = (lat2 - lat1) * rad_per_deg
    dlon_rad = (lon2 - lon1) * rad_per_deg

    lat1_rad, lon1_rad = lat1 * rad_per_deg, lon1 * rad_per_deg
    lat2_rad, lon2_rad = lat2 * rad_per_deg, lon2 * rad_per_deg

    a = Math.sin(dlat_rad / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    r_km * c
  end
end
