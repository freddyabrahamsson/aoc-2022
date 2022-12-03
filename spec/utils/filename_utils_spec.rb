# typed: false
# frozen_string_literal: true

describe Utils::FilenameUtils do
  context 'when producing dates for filenames' do
    it 'always produces strings of length 2' do
      (1..31).each { |n| expect(described_class.day_str(n).length).to eq 2 }
    end

    it 'produces a string which reads the same number' do
      (1..31).each { |n| expect(described_class.day_str(n).to_i).to eq n }
    end
  end

  context 'when producing zero padded strings' do
    it 'produces a string which has the right length' do
      100.times do
        len = rand(1..10)
        num = rand(10**len)
        expect(described_class.zero_padded_num(num, len).length).to eq len
      end
    end

    it 'produces a string which reads the same number' do
      100.times do
        len = rand(1..10)
        num = rand(10**len)
        expect(described_class.zero_padded_num(num, len).to_i).to eq num
      end
    end
  end
end
