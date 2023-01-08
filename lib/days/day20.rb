# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 20
  class Day20 < Day
    class LLNode < T::Struct
      extend T::Sig

      prop :val, Integer
      prop :prev, T.nilable(LLNode), default: nil
      prop :nxt,  T.nilable(LLNode), default: nil

      sig { params(offset: Integer).returns(LLNode) }
      def get_offset(offset)
        node = self
        offset.times { node = T.must(node.nxt) }
        node
      end

      sig { void }
      def disconnect
        nxt&.prev = prev
        prev&.nxt = nxt
      end

      sig { params(other_node: LLNode).void }
      def insert_after(other_node)
        other_node.prev = self
        other_node.nxt = nxt
        nxt&.prev = other_node
        self.nxt = other_node
      end
    end

    sig { params(lines: T::Array[String]).returns(T::Array[LLNode]) }
    def create_circle(lines)
      nodes = lines.map { |line| LLNode.new(val: line.to_i) }
      nodes.each_with_index do |node, idx|
        prev_idx = (idx - 1) % nodes.length
        next_idx = (idx + 1) % nodes.length
        node.prev = nodes[prev_idx]
        node.nxt = nodes[next_idx]
      end
      nodes
    end

    sig { params(nodes: T::Array[LLNode]).void }
    def rotate(nodes)
      nodes.each do |node|
        v = node.val % (nodes.length - 1)
        next if v.zero?

        node.disconnect
        node.get_offset(v).insert_after(node)
      end
    end

    sig { params(nodes: T::Array[LLNode]).returns(Integer) }
    def groove_coords(nodes)
      zero_node = T.must_because(nodes.find { |n| n.val.zero? }) { "Instructions promise a 0" }
      [1000, 2000, 3000].map { |offset| zero_node.get_offset(offset).val }.sum
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 20.
    #
    # @return the answer to part a, day 20.
    def part_a
      circle = create_circle(@input_lines)
      rotate(circle)
      groove_coords(circle)
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 20.
    #
    # @return the answer to part B, day 20.
    def part_b
      circle = create_circle(@input_lines).each { |node| node.val = node.val * 811_589_153 }
      10.times { rotate(circle) }
      groove_coords(circle)
    end
  end
end
