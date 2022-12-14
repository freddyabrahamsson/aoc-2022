# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day07"

##
# Test class for day 07
class TestDay07 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day07.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('07'.to_i)}")
    assert_equal 95_437, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day07.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('07'.to_i)}")
    assert_equal 24_933_642, d.part_b
  end

  sig { void }
  def test_invalid_node_from_ls_line
    fs = Days::Day07::FS.new
    assert_raises(ArgumentError) { fs.read_ls_line("invalid command") }
  end
end
