# typed: false
# frozen_string_literal: true

require_relative '../../lib/days/day02'
require_relative '../../lib/utils'

describe Days::Day02 do
  fn = Utils::FilenameUtils

  d = described_class.new
  d.read_file("#{fn::SPEC_INPUTS_DIR}/#{fn.input_fn('02'.to_i)}")

  context 'when attempting part A' do
    it 'solves the test case' do
      expect(d.part_a).to eq 15
    end
  end

  context 'when attempting part B' do
    it 'solves the test case' do
      expect(d.part_b).to eq 12
    end
  end
end
