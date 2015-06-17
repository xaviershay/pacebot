ENV['EXECJS_RUNTIME'] = 'Node'
require 'spec_helper'

describe 'formatting responses' do
  def assert_format(response, expected)
    bot = Pacebot.new
    assert_equal expected, bot.format(response)

    OpalHelper.with_opal do
      actual = OpalHelper.eval("Pacebot.new.format(#{response.to_ruby})")
      assert_equal expected, actual
    end
  end

  describe 'mile distance' do
    it 'formats with km equivalent' do
      assert_format R::MileDistance.new(10),
        "10 mi = 16.1 km"
    end
  end

  describe 'km distance' do
    it 'formats with mile equivalent' do
      assert_format R::KmDistance.new(8),
        "8 km = 5 mi"
    end
  end

  describe 'mile pace' do
    it 'formats with kay and lap equivalents' do
      assert_format R::MilePace.new(4 * 60),
        "4:00 mile = 2:29 km = 60s lap"
    end
  end

  describe 'kay pace' do
    it 'formats with mile and lap equivalents' do
      assert_format R::KmPace.new(4 * 60 + 15),
        "4:15 km = 6:50 mile = 102s lap"
    end
  end

  describe 'miles at pace' do
    it 'calculates total duration' do
      assert_format R::MilesAtPace.new(3, 4 * 60 + 20),
        "3mi @ 4:20 pace = 13:00"
    end

    it 'calculates total duration for partial miles' do
      assert_format R::MilesAtPace.new(3.5, 4 * 60 + 20),
        "3.5mi @ 4:20 pace = 15:10"
    end
  end

  describe 'miles in duration' do
    it 'calculates required pace' do
      assert_format R::MilesInDuration.new(3, 12 * 60 + 50),
        "3mi @ 4:17 pace = 12:50"
    end

    it 'calculates required pace for partial miles' do
      assert_format R::MilesInDuration.new(1.1, 4 * 60 + 30),
        "1.1mi @ 4:05 pace = 4:30"
    end
  end

  describe 'kays at pace' do
    it 'calculates total duration' do
      assert_format R::KmAtPace.new(3, 4 * 60 + 20),
        "3km @ 4:20 pace = 13:00"
    end

    it 'calculates total duration for partial miles' do
      assert_format R::KmAtPace.new(3.5, 4 * 60 + 20),
        "3.5km @ 4:20 pace = 15:10"
    end
  end

  describe 'kays in duration' do
    it 'calculates required pace' do
      assert_format R::KmInDuration.new(3, 12 * 60 + 50),
        "3km @ 4:17 pace = 12:50"
    end

    it 'calculates required pace for partial kays' do
      assert_format R::KmInDuration.new(1.1, 4 * 60 + 30),
        "1.1km @ 4:05 pace = 4:30"
    end

    it 'formats hours' do
      assert_format R::KmInDuration.new(10, 60 * 60),
        "10km @ 6:00 pace = 1:00:00"

      assert_format R::KmInDuration.new(10, 60 * 60 - 1),
        "10km @ 6:00 pace = 59:59"
    end
  end
end
