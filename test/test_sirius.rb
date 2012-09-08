require 'test/unit'
require 'suntrack'

# Test cases for Suntrack::Point3D and Suntrack::RAstro, to track the
# altitude/azimuth of Sirius.

class SiriusTest < Test::Unit::TestCase
  def test_somerset_nj_1
    x = DateTime.new(2012,1,16,0,0,0)
    # y component is elevation
    # z component is azimuth
    r = Suntrack.sirius_location(x,40.5,74.5)
    assert_equal r.y.round(3),9.598
    assert_equal r.z.round(3),238.104
  end
  def test_somerset_nj_2
    x = DateTime.new(2012,1,16,4,0,0)
    # y component is elevation
    # z component is azimuth
    r = Suntrack.sirius_location(x,40.5,74.5)
    assert_equal r.y.round(3),32.765
    assert_equal r.z.round(3),0.885
  end
end
