# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day03"

class TestDay03 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = T.let(Days::Day03.new, Days::Day03)
    d.read_file("#{FN::SPEC_INPUTS_DIR}/#{FN.input_fn('03'.to_i)}")
    assert_equal d.part_a, 157
  end

  sig { void }
  def test_part_b
    d = T.let(Days::Day03.new, Days::Day03)
    d.read_file("#{FN::SPEC_INPUTS_DIR}/#{FN.input_fn('03'.to_i)}")
    assert_equal d.part_b, 70
  end

  sig { void }
  def test_item_prio
    d = T.let(Days::Day03.new, Days::Day03)
    assert_equal d.item_prio("p"), 16
    assert_equal d.item_prio("L"), 38
    assert_equal d.item_prio("P"), 42
    assert_equal d.item_prio("v"), 22
    assert_equal d.item_prio("t"), 20
    assert_equal d.item_prio("s"), 19
  end
end
