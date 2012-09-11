require 'test/unit'
require 'suntrack'

# Test cases for Suntrack::Point3D and Suntrack::RAstro, to track the
# altitude/azimuth of a user-provided star

class UserProvidedTest < Test::Unit::TestCase
  def test_vega_somerset_nj_1
    x = DateTime.new(2012,1,16,0,0,0)
    # y component is elevation
    # z component is azimuth
    Suntrack.vega_declination=38.784
    Suntrack.vega_ra=18.616
    r = Suntrack.vega_location(x,40.5,74.5)
    assert_equal r.y.round(3),5.773
    assert_equal r.z.round(3),222.132
  end
end
