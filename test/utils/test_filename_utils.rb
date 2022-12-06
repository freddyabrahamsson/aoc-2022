# typed: strict
# frozen_string_literal: true

require "test_helper"

class TestFileNameUtils < Minitest::Test
  extend T::Sig
  FN = Utils::FilenameUtils

  sig { void }
  def test_day_str
    (1..31).each do |n|
      result = FN.day_str(n)
      assert_equal result.length, 2
      assert_equal result.to_i, n
    end
  end

  sig { void }
  def test_zero_padded_num
    100.times do
      len = rand(1..15)
      num = rand(10**len).to_i
      result = FN.zero_padded_num(num, len)
      assert_equal result.length, len
      assert_equal result.to_i, num
    end
  end
end
