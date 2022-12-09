# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day03"

##
# Test class for day 03
class TestDay03 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day03.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('03'.to_i)}")
    assert_equal 157, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day03.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('03'.to_i)}")
    assert_equal 70, d.part_b
  end

  sig { void }
  def test_item_prio
    d = Days::Day03.new
    assert_equal 16, d.item_prio("p")
    assert_equal 38, d.item_prio("L")
    assert_equal 42, d.item_prio("P")
    assert_equal 22, d.item_prio("v")
    assert_equal 20, d.item_prio("t")
    assert_equal 19, d.item_prio("s")
  end

  sig { void }
  def test_no_common_items
    b1 = Days::Day03::Bag.new("abcd", 2)
    b2 = Days::Day03::Bag.new("efgh", 2)

    assert_raises(ArgumentError) { Days::Day03.new.common([b1, b2]) }
  end
end
