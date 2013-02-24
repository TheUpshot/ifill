require 'rubygems'
require 'presdocs'
include Presdocs
require 'minitest/autorun'

class TestDocument < MiniTest::Unit::TestCase
  
  def setup
    @latest = Document.latest
    @categories = Category.all
    @locations = Document.with_locations
  end

  def test_that_there_are_five_latest_docs
    assert_equal 5, @latest.size
  end
  
  def test_that_latest_docs_dont_have_coords
    assert_nil @latest.first.lat
  end
  
  

end