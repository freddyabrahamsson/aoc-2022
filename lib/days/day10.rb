# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 10
  class Day10 < Day
    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 10.
    #
    # @return the answer to part a, day 10.
    def part_a
      cpu = CPU.new
      @input_lines.each do |line|
        cpu.execute(parse_instruction(line))
      end
      interesting_vals = [20, 60, 100, 140, 180, 220]
      cpu.x_vals.map { |k, v| interesting_vals.include?(k) ? k * v : 0 }.inject(:+)
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 10.
    #
    # @return the answer to part B, day 10.
    def part_b
      cpu = CPU.new
      @input_lines.each do |line|
        cpu.execute(parse_instruction(line))
      end
      d = CRT.new
      cpu.x_vals.each do |k, v|
        d.turn_on(k - 1) if ((k - 1) % 40 - v).abs <= 1
      end
      d.display
    end

    ##
    # A CRT
    class CRT
      extend T::Sig

      sig { void }
      def initialize
        @pixels = T.let(Array.new(6) { Array.new(40, ".") }, T::Array[T::Array[String]])
      end

      sig { returns(String) }
      def display
        "\n#{@pixels.map { |row| "#{row.join}\n" }.join}"
      end

      sig { params(num: Integer).void }
      def turn_on(num)
        T.must(@pixels[num / 40])[num % 40] = "#"
      end
    end

    ##
    # Mnemonics
    class Mnemonic < T::Enum
      enums do
        Addx = new
        Noop = new
      end
    end

    ##
    # An instruction
    class Instruction < T::Struct
      extend T::Sig

      const :mnem, Mnemonic
      const :args, T::Array[Integer]
    end

    MNEMONICS = T.let({
      addx: Mnemonic::Addx,
      noop: Mnemonic::Noop
    }.freeze, T::Hash[Symbol, Mnemonic])

    sig { params(instruction_string: String).returns(Instruction) }
    def parse_instruction(instruction_string)
      tokens = instruction_string.split(" ")
      mnem = MNEMONICS[T.must(tokens.first).to_sym]
      args = tokens.drop(1).map(&:to_i)
      Instruction.new(mnem: T.must(mnem), args:)
    end

    ##
    # A CPU
    class CPU
      extend T::Sig

      INSTRUCTION_CYCLES = T.let({ Mnemonic::Addx => 2,
                                   Mnemonic::Noop => 1 }.freeze, T::Hash[Mnemonic, Integer])

      sig { returns(T::Hash[Integer, Integer]) }
      attr_reader :x_vals

      sig { void }
      def initialize
        @clock_cycle = T.let(0, Integer)
        @registers = T.let(Hash.new(1), T::Hash[Symbol, Integer])
        @x_vals = T.let(Hash.new(1), T::Hash[Integer, Integer])
      end

      sig { params(cycles: Integer).void }
      def clock_tick(cycles)
        cycles.times do
          @clock_cycle += 1
          @x_vals[@clock_cycle] = T.must(@registers[:X])
        end
      end

      sig { params(instruction: Instruction).void }
      def execute(instruction)
        case instruction.mnem
        when Mnemonic::Addx
          clock_tick(2)
          @registers[:X] = T.must(@registers[:X]) + T.must(instruction.args.first)
        when Mnemonic::Noop
          clock_tick(1)
        end
      end
    end
  end
end
