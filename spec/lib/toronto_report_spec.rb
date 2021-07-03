# frozen_string_literal: true

require 'rspec/json_expectations'
require 'tempfile'

require_relative '../../lib/toronto_report'

describe TorontoReport do
  describe '#to_json' do
    let(:test_csv) do
      csv_text = <<~CSV
        Date,Algoma_Public_Health_Unit,Brant_County_Health_Unit,Chatham-Kent_Health_Unit,Durham_Region_Health_Department,Eastern_Ontario_Health_Unit,Grey_Bruce_Health_Unit,Haldimand-Norfolk_Health_Unit,"Haliburton,_Kawartha,_Pine_Ridge_District_Health_Unit",Halton_Region_Health_Department,Hamilton_Public_Health_Services,Hastings_and_Prince_Edward_Counties_Health_Unit,Huron_Perth_District_Health_Unit,"Kingston,_Frontenac_and_Lennox_&_Addington_Public_Health",Lambton_Public_Health,"Leeds,_Grenville_and_Lanark_District_Health_Unit",Middlesex-London_Health_Unit,Niagara_Region_Public_Health_Department,North_Bay_Parry_Sound_District_Health_Unit,Northwestern_Health_Unit,Ottawa_Public_Health,Peel_Public_Health,Peterborough_Public_Health,Porcupine_Health_Unit,"Region_of_Waterloo,_Public_Health",Renfrew_County_and_District_Health_Unit,Simcoe_Muskoka_District_Health_Unit,Southwestern_Public_Health,Sudbury_&_District_Health_Unit,Thunder_Bay_District_Health_Unit,Timiskaming_Health_Unit,Toronto_Public_Health,Wellington-Dufferin-Guelph_Public_Health,Windsor-Essex_County_Health_Unit,York_Region_Public_Health_Services,Total
        12/30/2020,0,25,21,158,16,1,4,8,114,69,5,17,4,40,12,67,82,6,1,68,441,3,0,69,4,65,46,2,5,0,998,20,144,408,2923
        12/31/2020,0,26,12,114,58,3,12,9,79,156,6,19,13,25,10,112,110,0,0,194,431,8,1,127,6,83,79,8,1,5,888,58,257,418,3328
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
          toronto: {
            new_cases: 998
          }
        },
        '2020-12-31': {
          toronto: {
            new_cases: 888
          }
        }
      )
    end
  end
end
