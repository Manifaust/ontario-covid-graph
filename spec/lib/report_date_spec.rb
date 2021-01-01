# frozen_string_literal: true

require_relative '../../lib/report_date'

describe ReportDate do
  it 'parses date with dashes' do
    rd = ReportDate.new('2020-02-26')

    expect(rd.to_s).to eq('2020-02-26')
  end

  it 'parses date with slashes' do
    rd = ReportDate.new('02/26/2020')

    expect(rd.to_s).to eq('2020-02-26')
  end

  describe '#day_number' do
    it 'returns the Julian day number' do
      rd = ReportDate.new('2020-02-26')

      expect(rd.day_number).to eq(Date.parse('2020-02-26').jd)
    end
  end

  describe '#eql?' do
    it 'compares using date' do
      date_a = described_class.new('2020-02-26')
      date_b = described_class.new('02/26/2020')

      expect(date_a.eql?(date_b)).to be(true)
    end
  end

  describe '#hash' do
    it 'returns the same value for two of the same dates' do
      date_a = described_class.new('2020-02-26')
      date_b = described_class.new('02/26/2020')

      expect(date_a.hash).to eq(date_b.hash)
    end

    it 'returns different values for different dates' do
      date_a = described_class.new('2020-02-26')
      date_b = described_class.new('2020-02-27')

      expect(date_a.hash).not_to eq(date_b.hash)
    end
  end

  describe '#prev_day' do
    it 'returns the day before' do
      date_of = described_class.new('2020-02-01')
      date_prev = date_of.prev_day

      expect(date_prev.to_s).to eq('2020-01-31')
    end
  end
end
