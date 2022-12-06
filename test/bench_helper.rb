# typed: strict
# frozen_string_literal: true

require "test_helper"
require "minitest/benchmark"
require "minitest/reporters"

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
