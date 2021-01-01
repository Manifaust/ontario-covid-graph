# frozen_string_literal: true

require_relative '../../lib/ltc_report'

describe LtcReport do
  describe '#to_json' do
    let(:test_csv) do
      csv_text = <<~CSV
        Reported Date,Confirmed Negative,Presumptive Negative,Presumptive Positive,Confirmed Positive,Resolved,Deaths,Total Cases,Total patients approved for testing as of Reporting Date,Total tests completed in the last day,Percent positive tests in last day,Under Investigation,Number of patients hospitalized with COVID-19,Number of patients in ICU with COVID-19,Number of patients in ICU on a ventilator with COVID-19,Total Positive LTC Resident Cases,Total Positive LTC HCW Cases,Total LTC Resident Deaths,Total LTC HCW Deaths
        2020-12-30,,,,20558,153799,4474,178831,7858200,39210,8.4,54955,1177,323,204,10830,4256,2738,8
        2020-12-31,,,,21617,156012,4530,182159,7922058,63858,5.7,72283,1235,337,210,11027,4280,2777,8
      CSV

      file = Tempfile.new
      file.write(csv_text)
      file.close
      file.path
    end

    it 'renders json' do
      report = described_class.new(test_csv)

      expect(report.to_json).to include_json(
        '2020-12-30': {
          ltc: {
            resident_total_cases: 10830,
            resident_total_deaths: 2738
          }
        },
        '2020-12-31': {
          ltc: {
            resident_total_cases: 11027,
            resident_new_cases: 197,
            resident_total_deaths: 2777
          }
        }
      )
    end
  end
end
