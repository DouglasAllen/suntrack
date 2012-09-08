# Astronomical methods, designed to be used in tandem with Suntrack::Point3D,
# from "Astronomy on the Personal Computer", by Montenbruck and Pfleger (1991).

class Suntrack::RAstro


  # Epoch constants for 1950 and 2000. Discussion on p. 15 of M&P.
  B1950_EPOCH = -0.500002108
  J2000_EPOCH = 0

  # Declination and right ascension of Sirius, for testing purposes, 
  # measured in degrees.
  SIRIUS_DECLINATION = -16.7306
  SIRIUS_RA = 6.75242

  # Sun position method.
  def self.sun_position(t)
    # Montebruck & Pfleger, page 36
    # Low-precision Sun position as a function of t
    # t is the number of T is the number of Julian centuries between the
    # epoch and J2000
    p2  = 6.283185307
    coseps = 0.91748
    sineps = 0.39778
    m  = p2*frac(0.993133+99.997361*t) 
    dl = 6893.0*sin(m)+72.0*sin(2*m)
    l  = p2*frac(0.7859453 + m/p2 + (6191.2*t+dl)/1296000);
    sl = sin(l)
    x = cos(l)
    y = coseps*sl
    z = sineps*sl
    rho = sqrt(1.0-z*z)
    declination = (360.0/p2)*atan(z/rho)
    right_ascension  = ( 48.0/p2)*atan(y/(x+rho))
    right_ascension = right_ascension + 24.0 if right_ascension < 0
    Suntrack::Point3D.new(0,declination,right_ascension)
  end

  # Local Mean Sidereal Time
  # M&P, page 38.
  def self.lmst(mjd,lambda)
    mjd0 = mjd.to_i
    ut = (mjd - mjd0) * 24
    t = (mjd0 - 51544.5) / 36525.0
    gmst = 6.697374558 + 1.0027379093*ut + (8640184.812866+(0.093104-6.2e-6*t)*t)*t/3600.0
    lmst = 24 * frac((gmst-(Float(lambda)/15)) / 24)
    lmst
  end

  # Utility method to get degrees/minutes/seconds from decimal degrees.
  # M&P, page 11
  def self.get_dms(ddd)
    pt = Suntrack::Point3D.new(0,0,0)
    pt.x = ddd.abs.to_i
    d1 = (ddd.abs - pt.x) * 60
    pt.y = d1.to_i
    pt.z = (d1 - pt.y) * 60
    pt.x = -pt.x if ddd < 0
    pt
  end

  # Utility method to convert Ruby DateTime to modified Julian date
  # M&P, page 12
  def self.to_mjd(date_time)
    a = (10000 * date_time.year) + (100 * date_time.month) + date_time.mday
    m = date_time.month
    y = date_time.year
    if date_time.month <= 2
      m = date_time.month + 12
      y = date_time.year - 1
    end
    leapDays = (y/400).to_i - (y/100).to_i + (y/4).to_i
    if a <= 15821004.1
      leapDays = -2 + ((y+4716)/4).to_i - 1179
    end
    a = (365 * y) - 679004
    a + leapDays + (30.6001 * (m + 1)).to_i + date_time.mday + (Float(date_time.hour)/24) + (Float(date_time.min)/1440) + (Float(date_time.sec)/86400)
  end

  # Utility method to convert modified Julian date to Julian dare
  # M&P, page 12
  def self.jd mjd
    mjd + 2400000.5
  end


  # Utility method to convert Julian date to time needed by Sun position
  # method
  def self.get_time jd
    (jd - 2451545)/36525
  end

  # Utility fraction method
  def self.frac(x)
    x = x - (x.to_i)
    x = x + 1 if x < 0
    x
  end
end
