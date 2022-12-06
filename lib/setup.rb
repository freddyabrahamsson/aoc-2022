# typed: strict
# frozen_string_literal: true

require "fileutils"
require "tty-logger"
require "tty-prompt"

require_relative "utils"

##
# Utilities to prepare solutions.
module Setup
  extend T::Sig

  FN = Utils::FilenameUtils # Define shorter names to save some space.
  NUMBER_RE = /XX/ # Pattern used in templates to mark where the date goes.
  LOGGER = T.let(TTY::Logger.new, TTY::Logger) # Default logger to output messages.

  sig { params(day: Integer).void }
  ##
  # Set up the following files for a given day.
  #
  # - Solver
  # - Test file
  # - Empty input file
  # - Empty test input
  #
  # @param day number of the day to set up.
  def self.setup_day(day)
    setup_day_solver(day)
    setup_day_test(day)
    touch_input(day)
    touch_test_input(day)
  end

  sig { params(day_num: Integer).void }
  ##
  # Touches the file for test inputs for a given day.
  #
  # @param day_num day to touch test input for
  def self.touch_test_input(day_num)
    filename = "#{FN::TEST_INPUTS_DIR}/#{FN.input_fn(day_num)}"
    return if File.exist?(filename)

    LOGGER.success("Created empty input: #{filename}")
    FileUtils.touch(filename)
  end

  sig { params(day_num: Integer).void }
  ##
  # Touches the file for real inputs for a given day.
  #
  # @param day_num day to touch test input for
  def self.touch_input(day_num)
    filename = "#{FN::INPUTS_DIR}/#{FN.input_fn(day_num)}"
    return if File.exist?(filename)

    LOGGER.success("Created empty input: #{filename}")
    FileUtils.touch(filename)
  end

  sig { params(day_num: Integer).void }
  ##
  # Copy the template for the Minitest for a day and update the file content to the correct day number.
  #
  # @param day_num day to copyt template for
  def self.setup_day_test(day_num)
    day_num_pp = FN.day_str(day_num)
    new_test_fn = "#{FN::TEST_DIR}/#{FN.test_fn(day_num)}"
    template_fn = "#{FN::TEMPLATE_DIR}/#{FN::TEST_TEMPLATE}"
    copy_template(template_fn, new_test_fn, NUMBER_RE, day_num_pp)
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

    if abort
      LOGGER.info "Skipping #{target_fn}"
      nil
    else
      file_content = File.read(source_fn)
      file_content = file_content.gsub(reg, ins)
      File.open(target_fn, "w") { |f| f << file_content }
      LOGGER.success "Copied template to #{target_fn}"
    end
  end
end
