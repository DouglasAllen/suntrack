# Main methods for Ruby version of calculations in  "Astronomy on the Personal
# Computer", by Montenbruck and Pfleger (1991).

class Suntrack

  @@attributes = {}

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

  # allow user to create new star location functions
  # User must define declination and right ascension
  def self.method_missing name, *args
    attribute = name.to_s
    if attribute =~ /=$/
      @@attributes[attribute.chop] = args[0]
    elsif attribute =~ /location/
      @@star = attribute.match(/(\w+)_location/)[1]
      begin
        dt = DateTime.now
        mjd = Suntrack::RAstro.to_mjd(args[0])
        tau = 15 * (Suntrack::RAstro.lmst(mjd,args[2]) - @@attributes["#{@@star}_ra"])
        z_in = Suntrack::Point3D.new(@@attributes["#{@@star}_declination"],tau,args[1])
        z = z_in.equatorial_to_horizon
        z
      rescue Exception => ex
        p "Suntrack ERROR: Please define declination and right ascension for #{@@star}"
      end
    end
  end
end
require 'suntrack/Point3D'
require 'suntrack/RAstro'
