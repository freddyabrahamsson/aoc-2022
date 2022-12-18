# typed: strict
# frozen_string_literal: true

require_relative "day"

##
# Extended Array
#
class Array
  extend T::Sig
  extend T::Generic

  sig { params(other: T::Array[T.untyped]).returns(T::Array[T.untyped]) }
  ##
  # Returns a new array, padded with nil-entries to match other.
  #
  # If other is shorter than this array, return self.
  #
  # @param other other array
  # @return TODO
  def nil_padded_to(other)
    this_len = length
    other_len = other.length
    return self if this_len >= other_len

    self + Array.new(other_len - this_len)
  end
end

module Days
  ##
  # Day 13
  class Day13 < Day
    ##
    # Represents a packet
    class Packet < T::Struct
      extend T::Sig
      prop :content, T::Array[T.any(Integer, Packet)]

      sig { params(line: String).returns(Packet) }
      def self.from_str(line)
        from_arr(JSON.parse(line))
      end

      sig { params(arr: T::Array[T.untyped]).returns(Packet) }
      def self.from_arr(arr)
        Packet.new(content: arr.map do |e|
          if e.instance_of?(Array)
            from_arr(e)
          elsif e.instance_of?(Integer)
            e
          else
            raise ArgumentError, "Invalid element '#{e}}'"
          end
        end)
      end

      sig { params(other: T.any(Packet, Integer)).returns(Integer) }
      def <=>(other)
        case other
        when Integer
          i_cmp(other)
        when Packet
          p_cmp(other)
        end
      end

      sig { params(other: Packet).returns(T::Boolean) }
      def <=(other)
        (self <=> other).zero? || (self <=> other) == -1
      end

      private

      sig { params(other: Packet).returns(Integer) }
      def p_cmp(other)
        content.nil_padded_to(other.content).zip(other.content).each do |this_e, other_e|
          return -1 if this_e.nil?
          return 1 if other_e.nil?

          res = case this_e
                when Packet
                  this_e <=> other_e
                when Integer
                  - (other_e <=> this_e)
                else
                  raise ArgumentError, "'#{this_e}' is nvalid type: #{this_e.class}"
                end
          return res unless res.zero?
        end
        0
      end

      sig { params(other: Integer).returns(Integer) }
      def i_cmp(other)
        self <=> Packet.new(content: [other])
      end
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 13.
    #
    # @return the answer to part a, day 13.
    def part_a
      pairs = @input_lines.split_on("").map { |pair| pair.map { |l| Packet.from_str(l) } }

      pairs.map.with_index(1) { |pair, x| pair[0] <= pair[1] ? x : 0 }.sum
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 13.
    #
    # @return the answer to part B, day 13.
    def part_b
      div_packet_a = Packet.from_arr([[2]])
      div_packet_b = Packet.from_arr([[6]])
      packets = @input_lines.reject(&:empty?).map { |line| Packet.from_str(line) } + [div_packet_a, div_packet_b]
      packets.sort!
      idx_a = T.must(packets.index(div_packet_a)) + 1
      idx_b = T.must(packets.index(div_packet_b)) + 1

      (idx_a * idx_b)
    end
  end
end
