require 'spec_helper'

describe 'pace detection' do
  def self.assert_parse(msg, expected)
    it "parses: #{msg}" do
      bot = Pacebot.new
      assert_equal expected, bot.parse(msg)
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
end
