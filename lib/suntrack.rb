# Main methods for Ruby version of calculations in  "Astronomy on the Personal
# Computer", by Montenbruck and Pfleger (1991).

class Suntrack

  # Return Sun location, in altitude(y) and azimuth(z), given 
  # DateTime, latitude and longitude
  def self.sun_location(date_time,latitude,longitude)

    mjd = Suntrack::RAstro.to_mjd(date_time)
    jd = Suntrack::RAstro.jd(mjd)
    tm = Suntrack::RAstro.get_time(jd)
    dec = Suntrack::RAstro.sun_position(tm)
    tau = 15 * (Suntrack::RAstro.lmst(mjd,longitude) - dec.z)
    z_in = Suntrack::Point3D.new(dec.y,tau,latitude)
    z = z_in.equatorial_to_horizon
    z
  end

  # Return Sirius location, in altitude(y) and azimuth(z), given 
  # DateTime, latitude and longitude
  def self.sirius_location(date_time,latitude,longitude)
    mjd = Suntrack::RAstro.to_mjd(date_time)
    tau = 15 * (Suntrack::RAstro.lmst(mjd,longitude) - Suntrack::RAstro::SIRIUS_RA)
    z_in = Suntrack::Point3D.new(Suntrack::RAstro::SIRIUS_DECLINATION,tau,latitude)
    z = z_in.equatorial_to_horizon
    z
  end
end
require 'suntrack/Point3D'
require 'suntrack/RAstro'
