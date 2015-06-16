class Pacebot
  MILE_MATCHER = "mi(?:les?)?"
  KM_MATCHER = "(?:kays|km?s?)"
  DURATION_MATCHER = "((\\d?:)?\\d?\\d:\\d{2})"

  def parse(msg)
    distance_matcher = /(\d+(?:\.\d+)?)\s*(#{MILE_MATCHER}|#{KM_MATCHER})\s+(@|in)\s+#{DURATION_MATCHER}/
    pace_matcher = /\b#{DURATION_MATCHER}\s?(#{MILE_MATCHER}|#{KM_MATCHER})/

    if match = distance_matcher.match(msg)
      duration, dist_type, calc, time = *match.captures
      dist = duration.to_f
      time = time.split(":").map(&:to_i)

      mappings = {
        ["@", "m"]  => Response::MilesAtPace,
        ["in", "m"] => Response::MilesInDuration,
        ["@", "k"]  => Response::KmAtPace,
        ["in", "k"] => Response::KmInDuration,
      }

      klass = mappings[[calc, dist_type[0]]]
      klass.new(dist, Pacebot.to_seconds(time))
    elsif match = pace_matcher.match(msg)
      duration, _, dist_type = *match.captures
      time = duration.split(":").map(&:to_i)
      klass = if dist_type[0] == "m"
        Response::MilePace
      else
        Response::KmPace
      end
      klass.new(Pacebot.to_seconds(time))
    end
  end

  def format(response)
    response.to_s
  end

  def self.to_seconds(time)
    if time.size == 2
      time[0] * 60 + time[1]
    elsif time.size == 3
      time[0] * 60 * 60 + time[1] * 60 + time[2]
    end
  end

  def self.format_duration(seconds)
    if seconds < 120
      "%is" % seconds.round
    elsif seconds >= 60 * 60
      "%i:%02i:%02i" % [seconds / 60 / 60, seconds / 60 % 60, seconds % 60]
    else
      "%i:%02i" % [seconds / 60, seconds % 60]
    end
  end

  module Response
    MILE_RATIO = 1.609
    LAP_RATIO = 0.4

    MilePace = Struct.new(:seconds) do
      def to_s
        "%s mile = %s km = %s lap" % [
          Pacebot.format_duration(seconds),
          Pacebot.format_duration(seconds / MILE_RATIO),
          Pacebot.format_duration(seconds / MILE_RATIO * LAP_RATIO)
        ]
      end
    end

    KmPace = Struct.new(:seconds) do
      def to_s
        "%s km = %s mile = %s lap" % [
          Pacebot.format_duration(seconds),
          Pacebot.format_duration(seconds * MILE_RATIO),
          Pacebot.format_duration(seconds * LAP_RATIO)
        ]
      end
    end

    AtPace = Struct.new(:distance, :seconds) do
      def to_s
        "%s%s @ %s pace = %s" % [
          distance.to_s,
          identifier,
          Pacebot.format_duration(seconds),
          Pacebot.format_duration(seconds * distance)
        ]
      end

      def identifier
        raise "Must implement in subclass"
      end
    end

    class MilesAtPace < AtPace
      def identifier; 'mi' end
    end

    class KmAtPace < AtPace
      def identifier; 'km' end
    end

    InDuration = Struct.new(:miles, :seconds) do
      def to_s
        "%s%s @ %s pace = %s" % [
          miles.to_s,
          identifier,
          Pacebot.format_duration((seconds / miles.to_f).round),
          Pacebot.format_duration(seconds)
        ]
      end
    end

    class MilesInDuration < InDuration
      def identifier; 'mi' end
    end

    class KmInDuration < InDuration
      def identifier; 'km' end
    end
  end
end

