# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day22"

##
# Test class for day 22
class TestDay22 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day22.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('22'.to_i)}")
    assert_equal 6032, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day22.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('22'.to_i)}")
    assert_raises(NotImplementedError) { d.part_b }
  end
end
