# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day08"

##
# Test class for day 08
class TestDay08 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = T.let(Days::Day08.new, Days::Day08)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    assert_equal 21, d.part_a
  end

  sig { void }
  def test_part_b
    d = T.let(Days::Day08.new, Days::Day08)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    assert_equal 8, d.part_b
  end

  sig { void }
  def test_read_grid
    lines = File.readlines("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    g = Days::Day08::Grid.new(lines.map(&:chomp))
    assert_equal 5, g.height, "Wrong height"
    assert_equal 5, g.width, "Wrong width"
  end

  sig { void }
  def test_height_at
    lines = File.readlines("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    g = Days::Day08::Grid.new(lines.map(&:chomp))
    assert_equal 3, g.height_at(1, 1)
    assert_equal 5, g.height_at(2, 2)
    assert_equal 6, g.height_at(1, 3)
    assert_equal 9, g.height_at(5, 4)
    assert_equal 0, g.height_at(5, 5)
  end

  sig { void }
  def test_h_vis
    lines = File.readlines("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    g = Days::Day08::Grid.new(lines.map(&:chomp))

    assert g.h_vis(1, 1), "(1,1) not h-visible"
    assert g.h_vis(2, 2), "(2,2) not h-visible"
    assert g.h_vis(3, 2), "(3,2) not h-visible"
    assert g.h_vis(3, 4), "(3,4) not h-visible"
  end

  sig { void }
  def test_v_vis
    lines = File.readlines("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    g = Days::Day08::Grid.new(lines.map(&:chomp))

    assert g.h_vis(1, 1), "(1,1) not v-visible"
    assert g.h_vis(2, 2), "(2,2) not v-visible"
    assert g.h_vis(3, 2), "(3,2) not v-visible"
    assert g.h_vis(3, 4), "(1,1) not v-visible"
  end

  sig { void }
  def test_vis
    lines = File.readlines("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    g = Days::Day08::Grid.new(lines.map(&:chomp))

    assert g.vis_from_edge(1, 4), "(1,4) not visible"
    assert g.vis_from_edge(5, 1), "(5,1) not visible"
    assert g.vis_from_edge(3, 2), "(3,2) not visible"
    assert g.vis_from_edge(3, 4), "(3,4) not visible"
  end

  sig { void }
  def test_los
    lines = File.readlines("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    g = Days::Day08::Grid.new(lines.map(&:chomp))

    assert_equal 1, g.los(3, 2, :up), "Wrong up-los for (3,2)"
    assert_equal 2, g.los(3, 2, :down), "Wrong down-los for (3,2)"
    assert_equal 2, g.los(3, 2, :right), "Wrong right-los for (3,2)"
    assert_equal 1, g.los(3, 2, :left), "Wrong left-los for (3,2)"
  end

  sig { void }
  def test_scenic_score
    lines = File.readlines("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('08'.to_i)}")
    g = Days::Day08::Grid.new(lines.map(&:chomp))

    assert_equal 4, g.scenic_score(3, 2), "Wrong scenic score for (3,2)"
    assert_equal 8, g.scenic_score(3, 4), "Wrong scenic score for (3,4)"
  end
end
