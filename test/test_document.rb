require 'rubygems'
require 'presdocs'
include Presdocs
require 'minitest/autorun'

class TestDocument < MiniTest::Unit::TestCase
  
  def setup
    @docs = Document.latest
  end

  def test_that_there_are_five_latest_docs
    assert_equal 5, @docs.size
  end

end