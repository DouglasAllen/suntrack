require 'test/unit'
require 'suntrack'
require 'date'

# Test cases for Suntrack::Point3D and Suntrack::RAstro, tracking the position
# of the Sun, in declination and right ascension, as a function of time.
# These results do not depend on latitude and longitude. For a given moment
# in time, declination/right ascension of the Sun is a specific point on the
# sky; latitude and longitude are then used along with an appropriate
# coordinate system to compute altitude and azimuth.

class SuntrackTest < Test::Unit::TestCase

  def test_point_one

    # August 7th 1997
    # http://www.stargazing.net/kepler/sun.html
    pointOne = DateTime.new(1997,8,7,11,0,0)
    mjd = Suntrack::RAstro.to_mjd(pointOne)
    assert_equal mjd.round(3), 50667.458
    jd = Suntrack::RAstro.jd(mjd)
    assert_equal jd.round(3), 2450667.958
    tm = Suntrack::RAstro.get_time(jd)
    assert_equal tm.round(4), -0.0240
    dec = Suntrack::RAstro.sun_position(tm)
    # Declination
    assert_equal dec.y.round(5), 16.34011
    # Right ascension
    assert_equal dec.z.round(5), 9.16339
  end

  def test_point_two

    pointTwo = DateTime.new(2004,1,3,11,0,0)
    mjd = Suntrack::RAstro.to_mjd(pointTwo)
    assert_equal mjd.round(3), 53007.458
    jd = Suntrack::RAstro.jd(mjd)
    assert_equal jd.round(3), 2453007.958
    tm = Suntrack::RAstro.get_time(jd)
    assert_equal tm.round(4), 0.0401
    dec = Suntrack::RAstro.sun_position(tm)
    # Declination
    assert_equal dec.y.round(5), -22.86037
    # Right ascension
    assert_equal dec.z.round(5), 18.89909
  end

  def test_point_three

    pointTwo = DateTime.new(2012,9,7,19,0,0)
    mjd = Suntrack::RAstro.to_mjd(pointTwo)
    assert_equal mjd.round(3), 56177.792
    jd = Suntrack::RAstro.jd(mjd)
    assert_equal jd.round(3), 2456178.292
    tm = Suntrack::RAstro.get_time(jd)
    assert_equal tm.round(4), 0.1269
    dec = Suntrack::RAstro.sun_position(tm)
    # Declination
    assert_equal dec.y.round(5), 5.69534
    # Right ascension
    assert_equal dec.z.round(5), 11.11341
  end

end
