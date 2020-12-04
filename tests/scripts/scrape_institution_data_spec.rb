require_relative "../../scripts/scrape_institution_data"

describe "Scrape Institutuion data" do 
    it "LTC table should find line with resident*" do 
        test_row = " Residents*                           N/A                   52                   8,726\n"
        expect(
            StartsWithLtcKeywordEndsInTwoNumbersRowSelect2.call(test_row)).to be(true)
    end 
end