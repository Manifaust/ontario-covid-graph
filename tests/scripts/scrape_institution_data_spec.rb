# frozen_string_literal: true

require_relative '../../scripts/scrape_institution_data'

describe ScrapeInstitutionData do
  describe '#get_page_text' do
    it 'uses the PDF Reader to read the page' do
      report_path = 'some_report'
      page0 = double('Fake Page 0', text: 'hey')
      page1 = double('Fake Page 1', text: 'bob')
      pages = [page0, page1]
      fake_report = double('Fake Report', pages: pages)
      expect(PDF::Reader).to receive(:new)
        .with(report_path)
        .and_return(fake_report)

      page_number = 1
      text = described_class.get_page_text(report_path, page_number)

      expect(text).to eq('hey')
    end
  end

  describe '#sum_data' do
    it 'sums data' do
      sample_data = {
        section1: {
          foo: 1,
          bar: 2
        }
      }
      described_class.sum_data(sample_data)

      expect(sample_data[:section1][:total]).to eq(3)
    end

    it 'does not remove fields from input' do
      sample_data = {
        section1: {
          foo: 1,
          bar: 2
        }
      }
      expected_sample_data = {
        section1: {
          foo: 1,
          bar: 2,
          total: 3
        }
      }
      described_class.sum_data(sample_data)

      expect(sample_data).to eq(expected_sample_data)
    end

    it 'does handle non number values' do
      sample_data = {
        section1: {
          foo: 1,
          bar: 2,
          nan: 'N/A'
        }
      }
      expected_sample_data = {
        section1: {
          foo: 1,
          bar: 2,
          nan: 'N/A',
          total: 3
        }
      }
      described_class.sum_data(sample_data)

      expect(sample_data).to eq(expected_sample_data)
    end
  end
end

describe 'StartsWithLtcKeywordEndsInTwoNumbersRowSelect2' do
  it 'LTC table should find line with resident*' do
    sample_row = " Residents*                           N/A                   52                   8,726\n"
    result = StartsWithLtcKeywordEndsInTwoNumbersRowSelect2.call(sample_row)
    expect(result).to be(true)
  end
end

