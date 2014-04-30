require 'rubygems'
require 'ifill'
include Ifill
require 'minitest/autorun'

class TestDocument < MiniTest::Test
  
  def setup
    @latest = Document.latest
    @categories = Category.all
    @locations = Document.with_locations
    @doc = Document.detail('DCPD-201300104')
    @date = Document.date('2/14/2013')
  end

  def test_that_there_are_five_latest_docs
    assert_equal 5, @latest.size
  end
  
  def test_that_latest_docs_dont_have_coords
    assert_nil @latest.first.lat
  end
  
  def test_that_categories_have_a_positive_count
    assert_operator @categories.count, :>=, 0
  end
  
  def test_that_location_docs_have_lat_and_lng
    assert @locations.last.lat
    assert @locations.first.lng
  end
  
  def test_that_document_detail_has_an_fdsys_url
    assert_equal "http://www.gpo.gov/fdsys/pkg/DCPD-201300104/html/DCPD-201300104.htm", @doc.fdsys_url
  end
  
  def test_that_document_date_results_are_from_same_date
    assert_equal Date.strptime('2/14/2013', '%m/%d/%Y'), @date.map{|d| d.date}.uniq.first
  end
  
  def test_that_date_range_raises_error_for_bad_dates
    assert_raises RuntimeError do 
      @range = Document.date_range('2/14/2013', '235')
    end
  end
  
end