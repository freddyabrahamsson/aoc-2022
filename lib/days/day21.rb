# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 21
  class Day21 < Day
    YELL_PATTERN = /(?<monkey>\w+): (?<number>\d+)/
    OP_PATTERN = /(?<monkey>\w+): (?<monkey_a>\w+) (?<op>\S) (?<monkey_b>\w+)/

    class Monkey
      extend T::Sig
      extend T::Helpers
      abstract!

      sig { params(name: Symbol).void }
      def initialize(name)
        @name = name
      end

      sig { abstract.returns(Integer) }
      def result; end

      sig { abstract.params(child_name: Symbol).returns(T::Boolean) }
      def has_child(child_name); end

      sig { abstract.params(target: Integer, child_name: Symbol).returns(Integer) }
      def solve_for(target, child_name); end
    end

    class YellingMonkey < Monkey
      sig { params(name: Symbol, number: Integer).void }
      def initialize(name, number)
        super(name)
        @number = number
      end

      sig { override.returns(Integer) }
      def result
        @number
      end

      sig { override.params(child_name: Symbol).returns(T::Boolean) }
      def has_child(child_name)
        child_name == @name
      end

      sig { override.params(target: Integer, child_name: Symbol).returns(Integer) }
      def solve_for(target, child_name)
        return target if child_name == @name

        raise ArgumentError, "Cannot solve for '#{target}' with var '#{child_name}', #{@name} has no children."
      end
    end

    class OpMonkey < Monkey
      sig { params(name: Symbol, monkey_a_name: Symbol, monkey_b_name: Symbol, operation: Symbol).void }
      def initialize(name, monkey_a_name, monkey_b_name, operation)
        super name
        @monkey_a_name = monkey_a_name
        @monkey_b_name = monkey_b_name
        @monkey_a = T.let(nil, T.nilable(Monkey))
        @monkey_b = T.let(nil, T.nilable(Monkey))
        @operation = operation
      end

      sig { params(monkeys: T::Hash[Symbol, Monkey]).void }
      def read_children(monkeys)
        @monkey_a = monkeys.fetch(@monkey_a_name)
        @monkey_b = monkeys.fetch(@monkey_b_name)
      end

      sig { override.returns(Integer) }
      def result
        raise StandardError unless @monkey_a && @monkey_b

        res_a = @monkey_a.result
        res_b = @monkey_b.result
        case @operation
        when :+
          res_a + res_b
        when :-
          res_a - res_b
        when :*
          res_a * res_b
        when :/
          res_a / res_b
        else
          raise ArgumentError
        end
      end

      sig { params(var_child: Symbol).returns(Integer) }
      def solve_for_equality(var_child)
        if @monkey_a&.has_child(var_child)
          @monkey_a.solve_for(T.must(@monkey_b).result, var_child)
        elsif @monkey_b&.has_child(var_child)
          @monkey_b.solve_for(T.must(@monkey_a).result, var_child)
        else
          raise ArgumentError, "Cannot solve for equality"
        end
      end

      sig { override.params(target: Integer, child_name: Symbol).returns(Integer) }
      def solve_for(target, child_name)
        return target if child_name == @name

        if @monkey_a&.has_child(child_name)
          solve_a_for(target, child_name)
        elsif @monkey_b&.has_child(child_name)
          solve_b_for(target, child_name)
        else
          raise ArgumentError, "#{@name} does not have any child called #{child_name}"
        end
      end

      sig { override.params(child_name: Symbol).returns(T::Boolean) }
      def has_child(child_name)
        direct_child = (@monkey_a_name == child_name) || (@monkey_b_name == child_name)
        descendant_a = @monkey_a.nil? ? false : @monkey_a.has_child(child_name)
        descendant_b = @monkey_b.nil? ? false : @monkey_b.has_child(child_name)
        (child_name == @name) || direct_child || descendant_a || descendant_b
      end

      private

      sig { params(target: Integer, child_name: Symbol).returns(Integer) }
      def solve_a_for(target, child_name)
        res_b = T.must(@monkey_b).result
        sub_target = case @operation
                     when :+
                       target - res_b
                     when :-
                       target + res_b
                     when :*
                       target / res_b
                     when :/
                       target * res_b
                     else
                       raise ArgumentError
                     end
        T.must(@monkey_a&.solve_for(sub_target, child_name))
      end

      sig { params(target: Integer, child_name: Symbol).returns(Integer) }
      def solve_b_for(target, child_name)
        res_a = T.must(@monkey_a).result
        sub_target = case @operation
                     when :+
                       target - res_a
                     when :-
                       res_a - target
                     when :*
                       target / res_a
                     when :/
                       res_a / target
                     else
                       raise ArgumentError
                     end
        T.must(@monkey_b&.solve_for(sub_target, child_name))
      end
    end

    sig { params(lines: T::Array[String]).returns(T::Hash[Symbol, Monkey]) }
    def init_monkeys(lines)
      h = T.let({}, T::Hash[Symbol, Monkey])
      lines.each do |line|
        if m = line.match(YELL_PATTERN)
          name = T.must(m[:monkey]).to_sym
          h[name] = YellingMonkey.new(name, m[:number].to_i)
        elsif m = line.match(OP_PATTERN)
          name = T.must(m[:monkey]).to_sym
          h[name] = OpMonkey.new(name,
                                 T.must(m[:monkey_a]).to_sym,
                                 T.must(m[:monkey_b]).to_sym,
                                 T.must(m[:op]).to_sym)
        end
      end
      h
    end

    sig { params(monkeys: T::Hash[Symbol, Monkey]).void }
    def link_monkeys(monkeys)
      monkeys.each_value do |monkey|
        T.cast(monkey, OpMonkey).read_children(monkeys) if monkey.instance_of?(OpMonkey)
      end
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 21.
    #
    # @return the answer to part a, day 21.
    def part_a
      monkeys = init_monkeys(@input_lines)
      link_monkeys(monkeys)
      monkeys.fetch(:root).result
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 21.
    #
    # @return the answer to part B, day 21.
    def part_b
      monkeys = init_monkeys(@input_lines)
      link_monkeys(monkeys)
      T.cast(monkeys.fetch(:root), OpMonkey).solve_for_equality(:humn)
    end
  end
end
