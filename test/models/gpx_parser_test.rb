require "test_helper"
require "tempfile"

class GpxParserTest < ActiveSupport::TestCase
  test "parse correctly extracts data from GPX file" do
    gpx_content = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <gpx version="1.1" creator="Manual">
        <trk>
          <name>Scenic Trail</name>
          <trkseg>
            <trkpt lat="40.7128" lon="-74.0060">
              <ele>100</ele>
              <time>2024-05-19T10:00:00Z</time>
            </trkpt>
            <trkpt lat="40.8128" lon="-74.0060">
              <ele>150</ele>
              <time>2024-05-19T11:30:00Z</time>
            </trkpt>
          </trkseg>
        </trk>
      </gpx>
    XML

    file = Tempfile.new([ "test", ".gpx" ])
    file.write(gpx_content)
    file.rewind

    result = GpxParser.parse(file.path)

    assert_equal "Scenic Trail", result[:trail_name]
    assert result[:distance_km] > 0
    assert_equal 50, result[:elevation_gain] # 150 - 100
    assert_equal "1h 30m", result[:duration]
    assert_equal 2, result[:points].count

    file.close
    file.unlink
  end
end
