# frozen_string_literal: true

require_relative '../../scripts/report_date'

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
end
