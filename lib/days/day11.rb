# typed: strict
# frozen_string_literal: true

require_relative "day"
require_relative "../day_utils/array_utils"
require_relative "../day_utils/integer_utils"
module Days
  ##
  # Day 11
  class Day11 < Day
    class TossedItem < T::Struct
      prop :item, Integer
      prop :target, Integer
    end

    ##
    # A monkey
    # @return TODO
    class Monkey < T::Struct
      extend T::Sig
      prop :items, T::Array[Integer]
      prop :op, Proc
      prop :test, Integer
      prop :t_target, Integer
      prop :f_target, Integer
      prop :inspected, Integer

      sig { returns(T::Array[TossedItem]) }
      def toss_items_a
        tossed = []
        while (item = items.pop)
          self.inspected += 1
          item = op.call(item) / 3
          target = test.divides?(item) ? t_target : f_target
          tossed << TossedItem.new(item:, target:)
        end
        tossed
      end

      sig { params(monkey: Integer).returns(T::Array[TossedItem]) }
      def toss_items_b(monkey)
        tossed = []
        while (item = items.pop)
          self.inspected += 1
          item = op.call(item) % monkey
          target = test.divides?(item) ? t_target : f_target
          tossed << TossedItem.new(item:, target:)
        end
        tossed
      end
    end

    sig { params(line: String).returns(T::Array[Integer]) }
    def parse_monkey_items(line)
      items = line.split(":").last&.split(",")&.map { |s| s.strip.to_i }
      raise ArgumentError, "Could not parse items from '#{line}'" unless items

      items
    end

    sig { params(line: String).returns(Proc) }
    def parse_operation(line)
      eq = line.split("new = old").last&.strip
      parts = eq&.split(" ")
      op = T.must(parts&.first&.strip)
      n  = T.must(parts&.last&.strip)
      T.must(build_proc(op, n))
    end

    sig { params(op_str: String, arg: String).returns(T.nilable(T.proc.params(arg0: Integer).returns(Integer))) }
    def build_proc(op_str, arg)
      case op_str
      when "+"
        arg.eql?("old") ? proc { |old| old + old } : proc { |old| old + arg.to_i }
      when "*"
        arg.eql?("old") ? proc { |old| old * old } : proc { |old| old * arg.to_i }
      end
    end

    sig { params(line: String).returns(Integer) }
    def parse_test_or_target(line)
      line.split(" ").last.to_i
    end

    sig { params(lines: T::Array[String]).returns(Days::Day11::Monkey) }
    def parse_monkey(lines)
      Monkey.new(items: parse_monkey_items(T.must(lines[1])),
                 op: parse_operation(T.must(lines[2])),
                 test: parse_test_or_target(T.must(lines[3])),
                 t_target: parse_test_or_target(T.must(lines[4])),
                 f_target: parse_test_or_target(T.must(lines[5])),
                 inspected: 0)
    end

    sig { params(monkeys: T::Array[Monkey]).void }
    def play_round_a(monkeys)
      monkeys.each do |m|
        tossed_items = m.toss_items_a
        tossed_items.each do |tossed_item|
          raise ArgumentError, "Tossed into the air '#{tossed_item.target}'" unless monkeys[tossed_item.target]

          T.must(monkeys[tossed_item.target]).items << tossed_item.item
        end
      end
    end

    sig { params(monkeys: T::Array[Monkey]).void }
    def play_round_b(monkeys)
      divisor = monkeys.map(&:test).inject(:*)
      monkeys.each do |m|
        tossed_items = m.toss_items_b(divisor)
        tossed_items.each do |tossed_item|
          raise ArgumentError, "Tossed into the air '#{tossed_item.target}'" unless monkeys[tossed_item.target]

          T.must(monkeys[tossed_item.target]).items << tossed_item.item
        end
      end
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 11.
    #
    # @return the answer to part a, day 11.
    def part_a
      monkeys = T.let([], T::Array[Monkey])
      @input_lines.split_on("").each do |lines|
        monkeys << parse_monkey(lines)
      end
      20.times { play_round_a(monkeys) }
      monkeys.map(&:inspected).sort.last(2).inject(:*)
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 11.
    #
    # @return the answer to part B, day 11.
    def part_b
      monkeys = T.let([], T::Array[Monkey])
      @input_lines.split_on("").each do |lines|
        monkeys << parse_monkey(lines)
      end
      10_000.times { play_round_b(monkeys) }
      monkeys.map(&:inspected).sort.last(2).inject(:*)
    end
  end
end
