# typed: false
# frozen_string_literal: true

require_relative '../../lib/days/day03'
require_relative '../../lib/utils'

describe Days::Day03 do
  fn = Utils::FilenameUtils

  d = described_class.new
  d.read_file("#{fn::SPEC_INPUTS_DIR}/#{fn.input_fn('03'.to_i)}")

  context 'when getting priorities' do
    it "finds the given priority for 'p'" do
      expect(d.item_prio('p')).to eq 16
    end

    it "finds the given priority for 'L'" do
      expect(d.item_prio('L')).to eq 38
    end

    it "finds the given priority for 'P'" do
      expect(d.item_prio('P')).to eq 42
    end

    it "finds the given priority for 'v'" do
      expect(d.item_prio('v')).to eq 22
    end

    it "finds the given priority for 't'" do
      expect(d.item_prio('t')).to eq 20
    end

    it "finds the given priority for 's'" do
      expect(d.item_prio('s')).to eq 19
    end
  end

  context 'when attempting part A' do
    it 'solves the test case' do
      expect(d.part_a).to eq 157
    end
  end

  context 'when attempting part B' do
    it 'solves the test case' do
      expect(d.part_b).to eq 70
    end
  end
end
