# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day20"

##
# Test class for day 20
class TestDay20 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day20.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('20'.to_i)}")
    assert_equal 3, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day20.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('20'.to_i)}")
    assert_equal 1_623_178_306, d.part_b
  end
end
