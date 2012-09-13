# Suntrack::Point3D
# 3D vector with transformation functions, from "Astronomy on the Personal
# Computer", by Montenbruck and Pfleger (1991)

include Math
class Suntrack::Point3D

  attr_accessor :x, :y, :z
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def to_s
    "(" + @x.to_s + "," + @y.to_s + "," + @z.to_s + ")"
  end

  # Convert to Cartesian, from polar. No attempt is made to confirm that
  # the original coordinates are polar (r, theta, phi). M&P, page 10.
  def polar_to_cartesian!
    # Note that this is 90-usual theta.
    rcst = @x * cs(@y)
    z = @x * sn(@y)
    @x = rcst * cs(@z)
    @y = rcst * sn(@z)
    @z = z
  end

  # Precess an ecliptic Cartesian point between two epochs
  # M&P, page 21
  # @param [Float] t1 Epoch constant for first epoch
  # @param [Float] t2 Epoch constant for second epoch
  def precess_ecliptic_cartesian!(t1,t2)
    a = pmat_ecliptic(t1,t2)
    x = @x
    y = @y
    z = @z
    @x = a[[0,0]] * x + a[[0,1]] * y + a[[0,2]] * z
    @y = a[[1,0]] * x + a[[1,1]] * y + a[[1,2]] * z
    @z = a[[2,0]] * x + a[[2,1]] * y + a[[2,2]] * z
  end

  # Precess an equatorial Cartesian point between two epochs
  # M&P, page 21
  # @param [Float] t1 Epoch constant for first epoch
  # @param [Float] t2 Epoch constant for second epoch
  def precess_equatorial_cartesian!(t1,t2)
    a = pmat_equatorial(t1,t2)
    x = @x
    y = @y
    z = @z
    @x = a[[0,0]] * x + a[[0,1]] * y + a[[0,2]] * z
    @y = a[[1,0]] * x + a[[1,1]] * y + a[[1,2]] * z
    @z = a[[2,0]] * x + a[[2,1]] * y + a[[2,2]] * z
  end

  # Convert to polar, from Cartesian
  # M&P, page 10
  def cartesian_to_polar!
    # Note that this is 90-usual theta
    x = @x
    y = @y
    z = @z
    rho = (x * x) + (y * y)
    @x = sqrt(rho + (z * z))
    @z = atn2(y, x)
    @z += 360 if @z < 0 
    @y = atn2(z, sqrt(rho))
  end

  # Convert ecliptic coordinates to equatorial coordinates, given an epoch
  # M&P, page 16
  def ecliptic_to_equatorial!(t)
    # Correction for ecliptic obliquity
    # M&P, page 15
    # Arises from slow alterations in the Earth's orbit as a result of 
    # perturbations from other planets.
    eps = 23.43929111-(46.815+(0.00059-0.001813*t)*t)*t/3600
    c = cs(eps)
    s = sn(eps)
    y = @y
    z = @z
    @y = (y * c) - (s * z)
    @z = (y * s) + (c * z)
  end

  # Convert equatorial coordinates to ecliptic coordinates, given an epoch
  def equatorial_to_ecliptic!(t)
    # Correction for ecliptic obliquity
    # M&P, page 15
    # Arises from slow alterations in the Earth's orbit as a result of 
    # perturbations from other planets.
  # @param [Float] t Epoch constant
    eps = 23.43929111-(46.815+(0.00059-0.001813*t)*t)*t/3600
    y = @y
    z = @z
    c = cs(eps)
    s = sn(eps)
    @y = (y * c) + (s * z)
    @z = (-1 * y * s) + (c * z)
  end

  # Convert equatorial coordinates to horizon coordinates
  # M&P, pp. 34-35
  # @return [Suntrack::Point3D] pt polar coordinates: the altitude (y) and azimuth(z) of the input vector
  def equatorial_to_horizon
    cs_phi = cs(@z)
    sn_phi = sn(@z)
    cs_dec = cs(@x)
    sn_dec = sn(@x)
    cs_tau = cs(@y)
    x = cs_dec * sn_phi * cs_tau - sn_dec * cs_phi
    y = cs_dec * sn(@y)
    z = cs_dec * cs_phi * cs_tau + sn_dec * sn_phi
    pt = Suntrack::Point3D.new(x,y,z)
    pt.cartesian_to_polar!
    pt
  end

  private

  # Precession matrix from one epoch to another, in ecliptic coordinates
  # M&P, page 20
  # @param [Float] t1 Epoch constant for first epoch
  # @param [Float] t2 Epoch constant for second epoch
  def pmat_ecliptic(t1,t2)
    sec = 3600
    dt = t2-t1
    ppi = 174.876383889 +( ((3289.4789+0.60622*t1)*t1) + ((-869.8089-0.50491*t1) + 0.03536*dt)*dt )/sec;
    pi = ( (47.0029-(0.06603-0.000598*t1)*t1)+ ((-0.03302+0.000598*t1)+0.000060*dt)*dt )*dt/sec;
    pa = ( (5029.0966+(2.22226-0.000042*t1)*t1)+ ((1.11113-0.000042*t1)-0.000006*dt)*dt )*dt/sec;
    c1 = cs(ppi+pa)
    c2 = cs(pi)  
    c3 = cs(ppi);
    s1 = sn(ppi+pa);  
    s2 = sn(pi)
    s3 = sn(ppi);
    a = Hash.new
    a[[0,0]] = c1*c3+s1*c2*s3
    a[[0,1]] = c1*s3-s1*c2*c3
    a[[0,2]] = -s1*s2
    a[[1,0]] = s1*c3-c1*c2*s3
    a[[1,1]] = s1*s3+c1*c2*c3
    a[[1,2]] = c1*s2
    a[[2,0]] = s2*s3
    a[[2,1]] = -s2*c3
    a[[2,2]] = c2
    a
  end

  # Precession matrix from one epoch to another, in equatorial coordinates
  # M&P, page 20
  # @param [Float] t1 Epoch constant for first epoch
  # @param [Float] t2 Epoch constant for second epoch
  def pmat_equatorial(t1,t2)
    sec = 3600
    dt = t2-t1
    zeta  =  ( (2306.2181+(1.39656-0.000139*t1)*t1)+ ((0.30188-0.000345*t1)+0.017998*dt)*dt )*dt/sec
    z =  zeta + ( (0.79280+0.000411*t1)+0.000205*dt)*dt*dt/sec
    theta = ( (2004.3109-(0.85330+0.000217*t1)*t1)- ((0.42665+0.000217*t1)+0.041833*dt)*dt )*dt/sec
    c1 = cs(z);  
    c2 = cs(theta)  
    c3 = cs(zeta)
    s1 = sn(z)
    s2 = sn(theta)  
    s3 = sn(zeta)
    a = Hash.new
    a[[0,0]] = -s1*s3+c1*c2*c3 
    a[[0,1]] = -s1*c3-c1*c2*s3 
    a[[0,2]] = -c1*s2
    a[[1,0]] = c1*s3+s1*c2*c3 
    a[[1,1]] = c1*c3-s1*c2*s3 
    a[[1,2]] = -s1*s2
    a[[2,0]] = s2*c3          
    a[[2,1]] = -s2*s3          
    a[[2,2]] = c2
    a
  end

  # Mathematical functions in degrees as needed
  def cs(x)
    cos(PI * x / 180)
  end
  def sn(x)
    sin(PI * x / 180)
  end
  def atn2(y,x)
    return 0 if x == 0 && y == 0
    ax = x.abs
    ay = y.abs
    phi = atan(Float(y)/x) * 180 / PI
    if (ay >= ax) 
      phi = 90 - (atan(Float(x)/y) * 180 / PI)
    end
    phi = 180 - phi if x < 0
    phi = -phi if y < 0
    phi
  end

end
