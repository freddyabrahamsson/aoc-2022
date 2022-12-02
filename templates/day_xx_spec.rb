# typed: false
# frozen_string_literal: true

require_relative '../../lib/days/dayXX'
require_relative '../../lib/utils'

describe Days::DayXX do
  fn = Utils::FilenameUtils

  d = described_class.new
  d.read_file("#{fn::SPEC_INPUTS_DIR}/#{fn.input_fn('XX'.to_i)}")

  context 'when attempting part A' do
    it 'solves the test case' do
      expect(d.part_a).to eq 0
    end
  end

  context 'when attempting part B' do
    it 'solves the test case' do
      expect(d.part_b).to eq 0
    end
  end
end
