# typed: strict
# frozen_string_literal: true

module Utils
  ##
  # Utilities for filenames
  module FilenameUtils
    extend T::Sig

    INPUTS_DIR = 'data/inputs'
    SPEC_DIR = 'spec/days'
    SPEC_INPUTS_DIR = 'data/spec'
    SOLVER_DIR = 'lib/days'
    TEMPLATE_DIR = 'templates'

    SOLVER_TEMPLATE = 'day_xx.rb'
    SPEC_TEMPLATE = 'day_xx_spec.rb'

    sig { params(day: Integer).returns(String) }
    def self.day_str(day)
      zero_padded_num(day, 2)
    end

    sig { params(num: Integer, target_length: Integer).returns(String) }
    def self.zero_padded_num(num, target_length)
      num_str = num.to_s
      initial_length = num_str.length
      raise ArgumentError, "#{num} has more than #{target_length} digits" if initial_length > target_length

      n_zeros = target_length - initial_length
      '0' * n_zeros + num_str
    end

    sig { params(day: Integer).returns(String) }
    def self.day_fn(day)
      "day#{day_str(day)}"
    end

    sig { params(day: Integer).returns(String) }
    def self.input_fn(day)
      "#{day_fn(day)}input.txt"
    end

    sig { params(day: Integer).returns(String) }
    def self.test_input_fn(day)
      "#{day_fn(day)}input_test.txt"
    end

    sig { params(day: Integer).returns(String) }
    def self.solver_fn(day)
      "#{day_fn(day)}.rb"
    end

    sig { params(day: Integer).returns(String) }
    def self.spec_fn(day)
      "#{day_fn(day)}_spec.rb"
    end
  end
end
