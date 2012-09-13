Gem::Specification.new do |s|
  s.name	= 'suntrack'
  s.version	= '0.0.4'
  s.date	= '2012-09-13'
  s.summary     = 'Suntrack offers methods for obtaining star positions given time, latitude and longitude'
  s.description = 'Sun position as function of time'
  s.authors 	= 'Joel M. Gottlieb'
  s.email	= 'joel.gottlieb@gmail.com'
  s.files	= ["lib/suntrack.rb","lib/suntrack/Point3D.rb","lib/suntrack/RAstro.rb"] + Dir['doc/*'] + Dir['test/*']
end
