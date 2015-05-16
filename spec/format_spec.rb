require 'spec_helper'

describe 'formatting responses' do
  def assert_format(response, expected)
    bot = Pacebot.new
    assert_equal expected, bot.format(response)
  end

  describe 'mile pace' do
    it 'formats with kay and lap equivalents' do
      assert_format R::MilePace.new(4 * 60), "4:00 mile = 2:29 km = 60s lap"
    end
  end

  describe 'kay pace' do
    it 'formats with mile and lap equivalents' do
      assert_format R::KmPace.new(4 * 60 + 15),
        "6:50 mile = 4:15 km = 102s lap"
    end
  end
end
