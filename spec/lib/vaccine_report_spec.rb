# frozen_string_literal: true

require_relative '../../lib/vaccine_report'

describe VaccineReport do
  describe '#to_json' do
    let(:test_csv) do
      csv_text = <<~CSV
        report_date,previous_day_doses_administered,total_doses_administered
        12/31/2020,"5,463","23,502"
        01/01/2021,"5,415","28,887"
      CSV

      file = Tempfile.new
      file.write(csv_text)
      file.close
      file.path
    end

    it 'renders json' do
      report = described_class.new(test_csv)

      expect(report.to_json).to include_json(
        '2020-12-31': {
          vaccine: {
            previous_day_doses: 5463,
            total_doses: 23_502
          }
        },
        '2021-01-01': {
          vaccine: {
            previous_day_doses: 5415,
            total_doses: 28_887
          }
        }
      )
    end
  end
end
