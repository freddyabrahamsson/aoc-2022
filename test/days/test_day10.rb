# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day10"

##
# Test class for day 10
class TestDay10 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day10.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('10'.to_i)}")
    assert_equal 13_140, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day10.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('10'.to_i)}")

    expected = <<-EXPECTED
    ##..##..##..##..##..##..##..##..##..##..
    ###...###...###...###...###...###...###.
    ####....####....####....####....####....
    #####.....#####.....#####.....#####.....
    ######......######......######......####
    #######.......#######.......#######.....
    EXPECTED

    expected_lines = expected.lines.map(&:strip)
    output_lines = d.part_b.to_s.strip.lines.map(&:strip)
    assert_equal expected_lines, output_lines
  end
end
