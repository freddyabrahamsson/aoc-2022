# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day13"

##
# Test class for day 13
class TestDay13 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils
  ARRAYS = T.let([[1, 1, 3, 1, 1],
                  [1, 1, 5, 1, 1],
                  [[1], [2, 3, 4]],
                  [[1], 4],
                  [9],
                  [[8, 7, 6]],
                  [[4, 4], 4, 4],
                  [[4, 4], 4, 4, 4],
                  [7, 7, 7, 7],
                  [7, 7, 7],
                  [],
                  [3],
                  [[[]]],
                  [[]],
                  [1, [2, [3, [4, [5, 6, 7]]]], 8, 9],
                  [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]].freeze, T::Array[T::Array[T.untyped]])

  sig { void }
  def test_part_a
    d = Days::Day13.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('13'.to_i)}")
    assert_equal 13, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day13.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('13'.to_i)}")
    assert_equal 140, d.part_b
  end

  sig { void }
  def test_packet_from_arr
    ARRAYS.each do |arr|
      p = Days::Day13::Packet.from_arr(arr)
      assert_instance_of Days::Day13::Packet, p, "Failed to read packet from '#{arr}'"
    end
  end

  sig { void }
  def test_packet_from_str
    File.readlines("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('13'.to_i)}").each do |line|
      next if line.strip.empty?

      p = Days::Day13::Packet.from_str(line)
      assert_instance_of Days::Day13::Packet, p, "Failed to read packet from '#{line}'"
    end
  end

  sig { void }
  def test_packet_to_int_comp
    p = Days::Day13::Packet.from_arr([1, 2, 3])
    assert_equal(-1, (p <=> 3))
    assert_equal(1, (p <=> 1))
  end

  sig { void }
  def test_packet_to_packet_comp_a
    p1a = Days::Day13::Packet.from_arr([1, 1, 3, 1, 1])
    p1b = Days::Day13::Packet.from_arr([1, 1, 5, 1, 1])
    assert_equal(-1, (p1a <=> p1b))

    p2a = Days::Day13::Packet.from_arr([[1], [2, 3, 4]])
    p2b = Days::Day13::Packet.from_arr([[1], 4])
    assert_equal(-1, (p2a <=> p2b))

    p3a = Days::Day13::Packet.from_arr([9])
    p3b = Days::Day13::Packet.from_arr([[8, 7, 6]])
    assert_equal(1, (p3a <=> p3b))
  end

  sig { void }
  def test_packet_to_packet_comp_b
    p4a = Days::Day13::Packet.from_arr([[4, 4], 4, 4])
    p4b = Days::Day13::Packet.from_arr([[4, 4], 4, 4, 4])
    assert_equal(-1, (p4a <=> p4b))

    p5a = Days::Day13::Packet.from_arr([7, 7, 7, 7])
    p5b = Days::Day13::Packet.from_arr([7, 7, 7])
    assert_equal(1, (p5a <=> p5b))

    p6a = Days::Day13::Packet.from_arr([])
    p6b = Days::Day13::Packet.from_arr([3])
    assert_equal(-1, (p6a <=> p6b))
  end

  sig { void }
  def test_packet_to_packet_comp_c
    p7a = Days::Day13::Packet.from_arr([[[]]])
    p7b = Days::Day13::Packet.from_arr([[]])
    assert_equal(1, (p7a <=> p7b))

    p8a = Days::Day13::Packet.from_arr([1, [2, [3, [4, [5, 6, 7]]]], 8, 9])
    p8b = Days::Day13::Packet.from_arr([1, [2, [3, [4, [5, 6, 0]]]], 8, 9])
    assert_equal(1, (p8a <=> p8b))
  end
end
