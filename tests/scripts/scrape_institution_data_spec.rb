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
end

describe 'StartsWithLtcKeywordEndsInTwoNumbersRowSelect2' do
  it 'LTC table should find line with resident*' do
    sample_row = " Residents*                           N/A                   52                   8,726\n"
    result = StartsWithLtcKeywordEndsInTwoNumbersRowSelect2.call(sample_row)
    expect(result).to be(true)
  end
end

