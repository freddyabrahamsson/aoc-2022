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
      if day.between?(0, 9)
        "0#{day}"
      else
        day.to_s
      end
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
