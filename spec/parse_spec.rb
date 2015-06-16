require 'spec_helper'

describe 'pace detection' do
  def self.assert_parse(msg, expected)
    it "parses: #{msg}" do
      bot = Pacebot.new
      assert_equal expected, bot.parse(msg)

      OpalHelper.with_opal do
        x = OpalHelper.eval("Pacebot.new.parse(#{msg.inspect}) == #{expected.to_ruby}")
        assert x, "failed"
      end
    end
  end

  def self.assert_no_parse(msg)
    it "does not parse: #{msg}" do
      bot = Pacebot.new
      assert_equal nil, bot.parse(msg)
    end
  end

  describe 'readme examples' do
    assert_parse "Those 4:00 miles were hard!", R::MilePace.new(4 * 60)
  end

  describe 'miles' do
    assert_parse "4:04 miles", R::MilePace.new(4 * 61)
    assert_parse "4:04 mile", R::MilePace.new(4 * 61)
    assert_parse "4:04 mi", R::MilePace.new(4 * 61)
    assert_parse "4:04mi", R::MilePace.new(4 * 61)
    assert_parse "10:00mi", R::MilePace.new(10 * 60)
    assert_no_parse "100:00mi"
  end

  describe 'kms' do
    assert_parse "5:00 kays", R::KmPace.new(5 * 60)
    assert_parse "5:00 km", R::KmPace.new(5 * 60)
    assert_parse "5:00 kms", R::KmPace.new(5 * 60)
    assert_parse "5:00 ks", R::KmPace.new(5 * 60)
    assert_parse "5:00km", R::KmPace.new(5 * 60)
  end

  describe 'miles at pace' do
    assert_parse "3 mi @ 4:00", R::MilesAtPace.new(3, 4 * 60)
    assert_parse "3.5 mi @ 4:00", R::MilesAtPace.new(3.5, 4 * 60)
    assert_parse "3mi @ 4:00", R::MilesAtPace.new(3, 4 * 60)
    assert_parse "3 miles @ 4:00", R::MilesAtPace.new(3, 4 * 60)
  end

  describe 'miles in duration' do
    assert_parse "3 mi in 13:00", R::MilesInDuration.new(3, 13 * 60)
    assert_parse "3.5 mi in 15:00", R::MilesInDuration.new(3.5, 15 * 60)
    assert_parse "3mi in 13:00", R::MilesInDuration.new(3, 13 * 60)
    assert_parse "3 mile in 13:00", R::MilesInDuration.new(3, 13 * 60)
    assert_parse "3 miles in 13:00", R::MilesInDuration.new(3, 13 * 60)
    assert_parse "3mi in 13:00", R::MilesInDuration.new(3, 13 * 60)
  end

  describe 'kays at pace' do
    assert_parse "3 km @ 4:00", R::KmAtPace.new(3, 4 * 60)
    assert_parse "3 kms @ 4:00", R::KmAtPace.new(3, 4 * 60)
    assert_parse "3 kays @ 4:00", R::KmAtPace.new(3, 4 * 60)
    assert_parse "3.5 km @ 4:00", R::KmAtPace.new(3.5, 4 * 60)
    assert_parse "3km @ 4:00", R::KmAtPace.new(3, 4 * 60)
    assert_parse "3k @ 4:00", R::KmAtPace.new(3, 4 * 60)
  end

  describe 'kays in duration' do
    assert_parse "3 km in 13:00", R::KmInDuration.new(3, 13 * 60)
    assert_parse "3k in 13:00", R::KmInDuration.new(3, 13 * 60)
    assert_parse "3.5 km in 15:00", R::KmInDuration.new(3.5, 15 * 60)
    assert_parse "3km in 13:00", R::KmInDuration.new(3, 13 * 60)
    assert_parse "3 km in 13:00", R::KmInDuration.new(3, 13 * 60)
    assert_parse "3 kays in 13:00", R::KmInDuration.new(3, 13 * 60)
    assert_parse "3k in 13:00", R::KmInDuration.new(3, 13 * 60)
    assert_parse "21.1k in 2:00:00", R::KmInDuration.new(21.1, 120 * 60)
  end

end
