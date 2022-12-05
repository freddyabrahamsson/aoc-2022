# typed: false
# frozen_string_literal: true

require_relative "../../lib/controller"

describe Controller do
  context "when producing dates for filenames" do
    it "creates a solver, given valid arguments" do
      solve_c = described_class.new(1, "solve")
      expect(solve_c).to be_a described_class
    end

    it "creates a setup controller, given valid arguments" do
      setup_c = described_class.new(1, "setup")
      expect(setup_c).to be_a described_class
    end
  end
end
