require 'test/unit'
require 'suntrack'

# Test cases for Suntrack::Point3D.

class Point3DTest < Test::Unit::TestCase

  # Confirm that we get expected results for basic transformations
  def test_ecliptic_Cartesian_1

    # Ecliptic point: radius, ecliptic latitude, ecliptic longitude
    # By setting the ecliptic latitude to zero, the point will be in the
    # xy plane
    pt = Suntrack::Point3D.new(1,0,30)
    pt.polar_to_cartesian!
    assert_equal pt.x.round(6), 0.866025
    assert_equal pt.y.round(6), 0.5
    assert_equal pt.z.round(6), 0.0
  end

  # Show the effect of precessing an ecliptic point between two epochs.
  def test_precessed_Cartesian_ecliptic

    # Spherical/Ecliptic/1950
    pt = Suntrack::Point3D.new(1,0,30)
    pt.polar_to_cartesian!
    # Cartesian/Ecliptic/1950
    pt.precess_ecliptic_cartesian!(Suntrack::RAstro::B1950_EPOCH,Suntrack::RAstro::J2000_EPOCH)
    # Cartesian/Ecliptic/2000
    assert_equal pt.x.round(6), 0.859866
    assert_equal pt.y.round(6), 0.510519
    assert_equal pt.z.round(6), 0.000067
  end

  # Show the effect of precessing an ecliptic point between two epochs, and
  # show how much the original polar coordinates are affected.
  def test_precessed_Cartesian_ecliptic_to_polar

    # Spherical/Ecliptic/1950
    pt = Suntrack::Point3D.new(1,0,30)
    pt.polar_to_cartesian!
    # Cartesian/Ecliptic/1950
    pt.precess_ecliptic_cartesian!(Suntrack::RAstro::B1950_EPOCH,Suntrack::RAstro::J2000_EPOCH)
    # Cartesian/Ecliptic/2000
    d = Suntrack::Point3D.new(pt.x,pt.y,pt.z)
    d.cartesian_to_polar!
    # Polar/Ecliptic/2000
    assert_equal d.x.round(6), 1.0
    assert_equal d.y.round(6), 0.003811
    assert_equal d.z.round(6), 30.698411
  end

  # The two approaches should give the same answer.
  def test_consistency_of_conversions

    # Spherical/Ecliptic/1950
    pt = Suntrack::Point3D.new(1,0,30)
    pt.polar_to_cartesian!
    # Cartesian/Ecliptic/1950
    pt.precess_ecliptic_cartesian!(Suntrack::RAstro::B1950_EPOCH,Suntrack::RAstro::J2000_EPOCH)
    # Cartesian/Ecliptic/2000
    d = Suntrack::Point3D.new(pt.x,pt.y,pt.z)
    d.cartesian_to_polar!
    # Polar/Ecliptic/2000

    pt.ecliptic_to_equatorial!(Suntrack::RAstro::J2000_EPOCH)
    # Cartesian/Equatorial/2000
    pt.equatorial_to_ecliptic!(Suntrack::RAstro::J2000_EPOCH)
    # Cartesian/Ecliptic/2000
    pt.cartesian_to_polar!
    # Polar/Ecliptic/2000
    assert_equal pt.x, d.x
    assert_equal pt.y.round(6), d.y.round(6)
    assert_equal pt.z, d.z
  end

  # Montebruck/Pfleger test case on page 31
  def test_MP_case

    # Equatorial point r = 1, delta = 0, alpha = 0, in B1950
    # delta = declination, alpha = right ascension
    pt = Suntrack::Point3D.new(1,0,0)
    pt.polar_to_cartesian!
    pt.precess_equatorial_cartesian!(Suntrack::RAstro::B1950_EPOCH,Suntrack::RAstro::J2000_EPOCH)
    pt.equatorial_to_ecliptic!(Suntrack::RAstro::J2000_EPOCH)
    pt.cartesian_to_polar!
    assert_equal pt.x.round(6), 1.0
    dms = Suntrack::RAstro.get_dms(pt.y)
    assert_equal dms.x, 0
    assert_equal dms.y, 0
    assert_equal dms.z.round(6), 2.335464
    dms = Suntrack::RAstro.get_dms(pt.z)
    assert_equal dms.x, 0
    assert_equal dms.y, 41
    assert_equal dms.z.round(6), 54.280965
  end
end
