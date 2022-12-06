# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

module Utils
  ##
  # Utilities for filenames
  module FilenameUtils
    extend T::Sig

    INPUTS_DIR = "data/inputs" # Path to directory where the actual inputs are stored.
    TEST_DIR = "test/days" # Path to directory where the test files for solutions are stored.
    TEST_INPUTS_DIR = "data/test" # Path to directory where the inputs for tests are stored.
    SOLVER_DIR = "lib/days" # Path to directory where the solutions are stored.
    TEMPLATE_DIR = "templates" # Path to directory where the templates for solutions and test files are stored.

    SOLVER_TEMPLATE = "day_xx.rb" # Name of the template for solutions.
    TEST_TEMPLATE = "test_day_xx.rb" # Name of the template for test files.

    sig { params(day: Integer).returns(String) }
    ##
    # Produce a zero padded day string for use in filenames.
    #
    # @param day date number
    # @return a zero padded string of length 2.
    # @raise ArgumentError if the input number is bigger than 31.
    def self.day_str(day)
      raise ArgumentError, "#{day} is never a date" if day > 31

      zero_padded_num(day, 2)
    end

    sig { params(num: Integer, target_length: Integer).returns(String) }
    ##
    # Produces a zero padded string representation of an integer, with the given length.
    #
    # @param num number to zero pad
    # @param target_length length of the output string
    # @return a zero padded string representation of the input number.
    # @raise ArgumentError if the input number has more than target_length digits.
    def self.zero_padded_num(num, target_length)
      num_str = num.to_s
      initial_length = num_str.length
      raise ArgumentError, "#{num} has more than #{target_length} digits" if initial_length > target_length

      n_zeros = target_length - initial_length
      "0" * n_zeros + num_str
    end

    sig { params(day: Integer).returns(String) }
    ##
    # Get the basic filename for files related to a given day.
    #
    # @param day day to get filename for
    # @return a standardised filename.
    def self.day_fn(day)
      "day#{day_str(day)}"
    end

    sig { params(day: Integer).returns(String) }
    ##
    # Get the name of the input file for a given day.
    #
    # @param day day to get filename for
    # @return the name of the input file for the given day.
    def self.input_fn(day)
      "#{day_fn(day)}input.txt"
    end

    sig { params(day: Integer, test_no: Integer).returns(String) }
    ##
    # Get the name of an alternative test file if there are multiple test cases given for a single day.
    #
    # @param day day to test
    # @param test_no test number
    # @return name of the inuput file
    def self.test_input_fn(day, test_no)
      "#{day_fn(day)}input#{test_no}.txt"
    end

    sig { params(day: Integer).returns(String) }
    ##
    # Get the name of the solution file for a given day.
    #
    # @param day day to get filename for
    # @return the name of the solution file for the given day.
    def self.solver_fn(day)
      "#{day_fn(day)}.rb"
    end

    sig { params(day: Integer).returns(String) }
    ##
    # Get the name of the test file for a given day.
    #
    # @param day day to get filename for
    # @return the name of the test file for tha given day.
    def self.test_fn(day)
      "test_#{day_fn(day)}.rb"
    end
  end
end
