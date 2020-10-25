module FinleapNearby
  module GeoCalculator
    extend self

    ##
    # Conversion factor: multiply by kilometers to get miles.
    #
    KM_IN_MI = 0.621371192

    ##
    # Radius of the Earth, in kilometers.
    # Value taken from: http://en.wikipedia.org/wiki/Earth_radius
    #
    EARTH_RADII = {km: 6371.0088}
    EARTH_RADII[:mi] = EARTH_RADII[:km] * KM_IN_MI

    # Not a number constant
    NAN = defined?(::Float::NAN) ? ::Float::NAN : 0 / 0.0

    ##
    # Distance between two points on Earth (Haversine formula).
    # Takes two points and an options hash.
    # The points are given in the same way that points are given to all
    # accept points as arguments. They can be:
    #
    # * an array of coordinates ([lat,lon])
    #
    # The options hash supports:
    #
    # * <tt>:units</tt> - <tt>:mi</tt> or <tt>:km</tt>
    #
    def distance(point1, point2, options = {})
      # convert to coordinate arrays
      point1 = extract_coordinates(point1)
      point2 = extract_coordinates(point2)

      # convert degrees to radians
      point1 = to_radians(point1)
      point2 = to_radians(point2)

      # compute deltas
      lat_diff = point2[0] - point1[0]
      lon_diff = point2[1] - point1[1]

      a = Math.sin(lat_diff / 2)**2 + Math.cos(point1[0]) *
        Math.sin(lon_diff / 2)**2 * Math.cos(point2[0])
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
      c * earth_radius(options[:units] || :km)
    end

    ##
    # Convert degrees to radians.
    # If an array (or multiple arguments) is passed,
    # converts each value and returns array.
    #
    def to_radians(*args)
      args = args.first if args.first.is_a?(Array)
      # noinspection RubyNilAnalysis
      if args.size == 1
        args.first * (Math::PI / 180)
      else
        args.map { |i| to_radians(i) }
      end
    end

    ##
    # Radius of the Earth in the given units (:mi or :km).
    #
    def earth_radius(units = :km)
      EARTH_RADII[units]
    end

    ##
    # Takes an object which is a [lat,lon] array
    #
    def extract_coordinates(point)
      if point.size == 2
        lat, lon = point
        if !lat.nil? && lat.respond_to?(:to_f) &&
            !lon.nil? && lon.respond_to?(:to_f)
          return [lat.to_f, lon.to_f]
        end
      end
      [NAN, NAN]
    end
  end
end
