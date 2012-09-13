# Main methods for Ruby version of calculations in  "Astronomy on the Personal
# Computer", by Montenbruck and Pfleger (1991).

class Suntrack

  @@attributes = {}

  # Returns Sun location, in altitude(sun_position.y) and 
  # azimuth(sun_position.z), given DateTime, latitude and longitude
  # @param [DateTime] date_time the date and time for Sun position
  # @param [Float] latitude the user's latitude, in degrees
  # @param [Float] longitude the user's longitude, in degrees
  # @return [Suntrack::Point3D] the altitude (y) and azimuth(z) of the Sun
  def self.sun_location(date_time,latitude,longitude)

    mjd = Suntrack::RAstro.to_mjd(date_time)
    jd = Suntrack::RAstro.jd(mjd)
    tm = Suntrack::RAstro.get_time(jd)
    dec = Suntrack::RAstro.sun_position(tm)
    tau = 15 * (Suntrack::RAstro.lmst(mjd,longitude) - dec.z)
    z_in = Suntrack::Point3D.new(dec.y,tau,latitude)
    sun_position = z_in.equatorial_to_horizon
    sun_position
  end

  # Returns Sirius location, in altitude(sirius_position.y) and 
  # azimuth(sirius_position.z), given DateTime, latitude and longitude
  # @param [DateTime] date_time the date and time for Sirius
  # @param [Float] latitude the user's latitude, in degrees
  # @param [Float] longitude the user's longitude, in degrees
  # @return [Suntrack::Point3D] the altitude (y) and azimuth(z) of Sirius
  def self.sirius_location(date_time,latitude,longitude)
    mjd = Suntrack::RAstro.to_mjd(date_time)
    tau = 15 * (Suntrack::RAstro.lmst(mjd,longitude) - Suntrack::RAstro::SIRIUS_RA)
    z_in = Suntrack::Point3D.new(Suntrack::RAstro::SIRIUS_DECLINATION,tau,latitude)
    sirius_position = z_in.equatorial_to_horizon
    sirius_position
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
