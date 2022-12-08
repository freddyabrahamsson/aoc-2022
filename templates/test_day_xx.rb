# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/dayXX"

##
# Test class for day XX
class TestDayXX < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = T.let(Days::DayXX.new, Days::DayXX)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('XX'.to_i)}")
    assert_raises(NotImplementedError) { d.part_a }
  end

  sig { void }
  def test_part_b
    d = T.let(Days::DayXX.new, Days::DayXX)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('XX'.to_i)}")
    assert_raises(NotImplementedError) { d.part_b }
  end
end
