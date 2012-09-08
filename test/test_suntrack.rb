require 'test/unit'
require 'suntrack'

# Test cases for Suntrack::Point3D and RAstro, to track the position of the
# Sun as a function of time, in altitude and azimuth.

class SuntrackTest < Test::Unit::TestCase

  def test_somerset_nj
    x = DateTime.new(2012,9,7,19,0,0)
    # y component is elevation
    # z component is azimuth
    r = Suntrack.sun_location(x,40.5,74.5)
    assert_equal r.y.round(3),45.453
    assert_equal r.z.round(3),47.026
  end

  def test_miami_fl
    x = DateTime.new(2012,9,7,19,30,0)
    # y component is elevation
    # z component is azimuth
    r = Suntrack.sun_location(x,25.76,80.21)
    assert_equal r.y.round(3),52.751
    assert_equal r.z.round(3),63.075
  end

  def test_san_francisco
    x = DateTime.new(2012,9,7,19,45,0)
    # y component is elevation
    # z component is azimuth
    r = Suntrack.sun_location(x,37.766,122.42)
    assert_equal r.y.round(3),57.513
    assert_equal r.z.round(3),10.446
  end
end
