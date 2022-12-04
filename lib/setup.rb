# typed: strict
# frozen_string_literal: true

require 'fileutils'
require 'tty-prompt'

require_relative 'utils'

##
# Utilities to prepare solutions.
module Setup
  extend T::Sig

  FN = Utils::FilenameUtils # Define shorter names to save some space.
  NUMBER_RE = /XX/ # Pattern used in templates to mark where the date goes.

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

  sig { params(day_num: Integer).void }
  ##
  # Touches the file for test inputs for a given day.
  #
  # @param day_num day to touch test input for
  def self.touch_test_input(day_num)
    filename = "#{FN::SPEC_INPUTS_DIR}/#{FN.input_fn(day_num)}"
    FileUtils.touch(filename) unless File.exist?(filename)
  end

  sig { params(day_num: Integer).void }
  ##
  # Touches the file for real inputs for a given day.
  #
  # @param day_num day to touch test input for
  def self.touch_input(day_num)
    filename = "#{FN::INPUTS_DIR}/#{FN.input_fn(day_num)}"
    FileUtils.touch(filename) unless File.exist?(filename)
  end

  sig { params(day_num: Integer).void }
  ##
  # Copy the template for the rspec test for a day and update the file content to the correct day number.
  #
  # @param day_num day to copyt template for
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
  # @param day_num number of the day to initialise.
  def self.setup_day_solver(day_num)
    day_num_pp = FN.day_str(day_num)
    new_day_fn = "#{FN::SOLVER_DIR}/#{FN.solver_fn(day_num)}"
    template_fn = "#{FN::TEMPLATE_DIR}/#{FN::SOLVER_TEMPLATE}"
    copy_template(template_fn, new_day_fn, NUMBER_RE, day_num_pp)
  end

  sig { params(source_fn: String, target_fn: String, reg: Regexp, ins: String).void }
  ##
  # Copy a template and change the file content by replacing a given pattern.
  #
  # @param source_fn template file
  # @param target_fn target file
  # @param reg pattern to replace
  # @param ins string to insert as replacement
  def self.copy_template(source_fn, target_fn, reg, ins)
    abort = false
    abort = TTY::Prompt.new.no?("#{target_fn} already exists. Do you want to overwrite?") if File.exist? target_fn
    return if abort

    new_spec_content = File.read(source_fn)
    new_spec_content = new_spec_content.gsub(reg, ins)
    File.open(target_fn, 'w') { |f| f << new_spec_content }
  end
end
