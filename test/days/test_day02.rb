# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day02"

##
# Test class for day 02
class TestDay02 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day02.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('02'.to_i)}")
    assert_equal 15, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day02.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('02'.to_i)}")
    assert_equal 12, d.part_b
  end

  sig { void }
  def test_winning_target_move
    d = Days::Day02.new
    assert_equal :rock, d.target_move(:win, :scissors)
    assert_equal :paper, d.target_move(:win, :rock)
    assert_equal :scissors, d.target_move(:win, :paper)
  end

  sig { void }
  def test_losing_target_move
    d = Days::Day02.new
    assert_equal :paper, d.target_move(:lose, :scissors)
    assert_equal :scissors, d.target_move(:lose, :rock)
    assert_equal :rock, d.target_move(:lose, :paper)
  end

  sig { void }
  def test_draw_target_move
    d = Days::Day02.new
    assert_equal :rock, d.target_move(:draw, :rock)
    assert_equal :paper, d.target_move(:draw, :paper)
    assert_equal :scissors, d.target_move(:draw, :scissors)
  end

  sig { void }
  def test_game_score_rock
    d = Days::Day02.new
    assert_equal 7, d.game_score(:rock, :scissors)
    assert_equal 4, d.game_score(:rock, :rock)
    assert_equal 1, d.game_score(:rock, :paper)
  end

  sig { void }
  def test_game_score_paper
    d = Days::Day02.new
    assert_equal 8, d.game_score(:paper, :rock)
    assert_equal 5, d.game_score(:paper, :paper)
    assert_equal 2, d.game_score(:paper, :scissors)
  end

  sig { void }
  def test_game_score_scissors
    d = Days::Day02.new
    assert_equal 9, d.game_score(:scissors, :paper)
    assert_equal 6, d.game_score(:scissors, :scissors)
    assert_equal 3, d.game_score(:scissors, :rock)
  end
end
