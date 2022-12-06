# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../lib/controller"

class TestFileNameUtils < Minitest::Test
  extend T::Sig

  sig { void }
  def test_initialize
    solve_c = Controller.new(1, "solve")
    setup_c = Controller.new(1, "setup")

    assert_instance_of Controller, solve_c
    assert_instance_of Controller, setup_c
  end
end
