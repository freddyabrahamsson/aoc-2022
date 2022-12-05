# typed: strict
# frozen_string_literal: true

require_relative 'day'

module Days
  ##
  # Day 03
  class Day03 < Day
    sig { returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 03.
    #
    # @return the answer to part a, day 03.
    def part_a
      bags = @input_lines.map { |s| Bag.new(s, 2) }
      (bags.map { |bag| overlapping_priority(bag) }).inject(:+)
    end

    sig { returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 03.
    #
    # @return the answer to part B, day 03.
    def part_b
      raise ArgumentError, 'Can not divide into even groups of 3' unless (@input_lines.length % 3).zero?

      bags = @input_lines.map { |s| Bag.new(s, 2) }
      (bags.each_slice(3).to_a.map { |group| item_prio(common(group)) }).inject(:+)
    end

    ##
    # A bag
    class Bag
      extend T::Sig

      sig { returns(T::Array[T::Hash[String, Integer]]) }
      attr_reader :compartments

      sig { params(items: String, n_comp: Integer).void }
      def initialize(items, n_comp)
        content = items.clone
        n_items = content.length

        raise ArgumentError, "Can't divide #{n_items} items into #{n_comp} groups" unless (n_items % n_comp).zero?

        comp_size = n_items / n_comp
        @compartments = T.let([], T::Array[T::Hash[String, Integer]])
        @compartments << parse_compartment(T.must(content.slice!(0...comp_size))) until content.empty?
      end

      sig { returns(T::Hash[String, Integer]) }
      ##
      # Get the full content of the bag.
      #
      # @return a single hash with the count of all items.
      def all_content
        @compartments.inject({}) { |content, comp| content.merge!(comp) { |_, va, vb| va + vb } }
      end

      sig { returns(String) }
      ##
      # Returns a strings with the items appearing in all compartments
      #
      # @return a string with the overlap
      def overlapping
        overlap = ''
        return overlap unless @compartments[0]

        T.must(@compartments[0]).each_key { |k| overlap += k.to_s if @compartments.all? { |c| c.key?(k) } }
        overlap
      end

      private

      sig { params(items: String).returns(T::Hash[String, Integer]) }
      ##
      # Read the content of a compartment from a string
      #
      # @param items string of items
      # @return hash with the count of each item.
      def parse_compartment(items)
        comp = Hash.new(0)
        items.each_char { |c| comp[c] += 1 }
        comp
      end
    end

    sig { params(bags: T::Array[Bag]).returns(String) }
    ##
    # Find an item common to all bags in an array.
    #
    # @param bags array of bags to search through
    # @return an item which exists in all bags.
    def common(bags)
      T.must(bags[0]).all_content.each_key { |k| return k if bags.all? { |b| b.all_content.key? k } }
      raise ArgumentError, 'no common item found'
    end

    sig { params(bag: Bag).returns(Integer) }
    ##
    # Get the total priority of all overlapping items in a bag
    #
    # @param bag bag to look thorugh
    # @return the total priority of all items found in both compartments.
    def overlapping_priority(bag)
      bag.overlapping.each_char.map { |c| item_prio(c) }.inject(:+)
    end

    sig { params(item: String).returns(Integer) }
    ##
    # Get the priority for an item.
    #
    # "a" through "z" have priorities 1 through 26
    # "A" through "Z" have priorities 27 through 52
    #
    # @param item item to get priority for
    # @return priority of the item.
    def item_prio(item)
      raise ArgumentError unless item.length == 1

      return (1 + item.ord - 'a'.ord) if ('a'..'z').include?(item)
      return (27 + item.ord - 'A'.ord) if ('A'..'Z').include?(item)

      raise ArgumentError, "#{item} is not a valid item"
    end
  end
end
