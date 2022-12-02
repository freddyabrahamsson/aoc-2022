# typed: strict
# frozen_string_literal: true

require_relative 'utils'

##
# Utilities to setup
module Setup
  extend T::Sig

  FN = Utils::FilenameUtils
  NUMBER_RE = /XX/

  sig { params(day: Integer).void }
  ##
  # Set up the following files for a given day.
  #
  # - Solver
  # - Test spec
  # - Empty input file
  # - Empty test input
  #
  # @param day number of the day to set up.
  def self.setup_day(day)
    setup_day_solver(day)
    setup_day_spec(day)
    touch_input(day)
    touch_test_input(day)
  end

  sig { params(day_num: Integer).returns(File) }
  def self.touch_test_input(day_num)
    File.open("#{FN::SPEC_INPUTS_DIR}/#{FN.input_fn(day_num)}", 'w') { |f| f << '' }
  end

  sig { params(day_num: Integer).void }
  def self.touch_input(day_num)
    File.open("#{FN::INPUTS_DIR}/#{FN.input_fn(day_num)}", 'w') { |f| f << '' }
  end

  sig { params(day_num: Integer).void }
  ##
  # Copy the template for the rspec test for a day and update the file content to the correct day number.
  #
  # @param day_num TODO
  def self.setup_day_spec(day_num)
    day_num_pp = FN.day_str(day_num)
    new_spec_fn = "#{FN::SPEC_DIR}/#{FN.spec_fn(day_num)}"
    template_fn = "#{FN::TEMPLATE_DIR}/#{FN::SPEC_TEMPLATE}"
    copy_template(template_fn, new_spec_fn, NUMBER_RE, day_num_pp)
  end

  sig { params(day_num: Integer).void }
  ##
  # Copy the template for the solution to a day and update the file content to the correct day number.
  #
  # @param day number of the day to initialise.
  def self.setup_day_solver(day_num)
    day_num_pp = FN.day_str(day_num)
    new_day_fn = "#{FN::SOLVER_DIR}/#{FN.solver_fn(day_num)}"
    template_fn = "#{FN::TEMPLATE_DIR}/#{FN::SOLVER_TEMPLATE}"
    copy_template(template_fn, new_day_fn, NUMBER_RE, day_num_pp)
  end

  sig { params(source_fn: String, target_fn: String, reg: Regexp, ins: String).void }
  def self.copy_template(source_fn, target_fn, reg, ins)
    new_spec_content = File.read(source_fn)
    new_spec_content = new_spec_content.gsub(reg, ins)
    File.open(target_fn, 'w') { |f| f << new_spec_content }
  end
end
