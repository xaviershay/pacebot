class Pacebot
  def parse(msg)
    case msg
    when /\b(\d?\d:\d{2})\s?mi(les?)?/
      time = $1.split(":").map(&:to_i)
      Response::MilePace.new(time[0] * 60 + time[1])
    when /\b(\d?\d:\d{2})\s?(kays|km?s?)?/
      time = $1.split(":").map(&:to_i)
      Response::KmPace.new(time[0] * 60 + time[1])
    end
  end

  def format(response)
    response.to_s
  end

  def self.format_duration(seconds)
    if seconds < 120
      "%is" % seconds.round
    else
      "%i:%02i" % [seconds / 60, seconds % 60]
    end
  end

  module Response
    MILE_RATIO = 1.609
    LAP_RATIO = 0.4

    MilePace = Struct.new(:seconds) do
      def inspect
        "<MilePace #{seconds}>"
      end

      def to_s
        "%s mile = %s km = %s lap" % [
          Pacebot.format_duration(seconds),
          Pacebot.format_duration(seconds / MILE_RATIO),
          Pacebot.format_duration(seconds / MILE_RATIO * LAP_RATIO)
        ]
      end
    end

    KmPace = Struct.new(:seconds) do
      def inspect
        "<KmPace #{seconds}>"
      end

      def to_s
        "%s mile = %s km = %s lap" % [
          Pacebot.format_duration(seconds * MILE_RATIO),
          Pacebot.format_duration(seconds),
          Pacebot.format_duration(seconds * LAP_RATIO)
        ]
      end
    end
  end
end

