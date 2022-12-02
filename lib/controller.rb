# typed: strict
# frozen_string_literal:true

require_relative 'days'
require_relative 'utils'
require_relative 'setup'

##
# Functions for implementing the CLI interface
class Controller
  extend T::Sig

  COMMANDS = T.let(%i[solve setup test].freeze, T::Array[Symbol])

  sig { params(day: Integer, command: String).void }
  def initialize(day, command)
    @day = day
    @command = T.let(parse_action(command), Symbol)
  end

  sig { void }
  def run
    case @command
    when :solve
      solve_and_print
    when :setup
      Setup.setup_day(@day)
    end
  end

  private

  sig { void }
  def solve_and_print
    day_solver = T.must(Days::IMPLEMENTED_DAYS[@day]).new
    day_solver.read_file("#{Utils::FilenameUtils::INPUTS_DIR}/#{Utils::FilenameUtils.input_fn(@day)}")
    puts "Day #{@day}"
    solve_and_print_a(day_solver)
    solve_and_print_b(day_solver)
  rescue TypeError
    puts "Day #{@day} is not yet implemented."
  end

  sig { params(day_solver: Days::Day).returns(NilClass) }
  def solve_and_print_a(day_solver)
    puts "Part A: #{day_solver.part_a}"
  rescue NotImplementedError
    puts 'Part A is not implemented'
  end

  sig { params(day_solver: Days::Day).returns(NilClass) }
  def solve_and_print_b(day_solver)
    puts "Part B: #{day_solver.part_b}"
  rescue NotImplementedError
    puts 'Part B is not implemented'
  end

  sig { params(input_string: String).returns(Symbol) }
  ##
  # Parse an action symbol from a given command string.
  #
  # @param input_string command name
  # @return symbol representing the action
  def parse_action(input_string)
    action_sym = input_string.to_sym
    return action_sym if COMMANDS.include?(action_sym)

    raise ArgumentError, "Unknown action '#{input_string}'"
  end

  sig { params(input_string: String).returns(Integer) }
  ##
  # Parse and validate a day. Valid days are from 1 to 25 (inclusive).
  #
  # @param input_string string representation of a day number
  # @return the number parsed
  def parse_day(input_string)
    day = Integer(input_string)
    raise ArgumentError unless day.between?(1, 25)

    day
  end
end
