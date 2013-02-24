require 'open-uri'

module Presdocs
  class Document
    
    attr_reader :location, :title, :source, :president, :date, :package_id
   
    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
    end
    
    def self.latest
      url = "http://m.gpo.gov/wscpd/mobilecpd/home"
      results = Oj.load(open(url).read)
      create_recent_documents(results['searchResults'])
    end
    
    def self.create_recent_documents(results)
      docs = []
      results.each do |result|
        docs << self.new  :id => results['packageId'],
                  :location => results['location'],
                  :title => results['line1'],
                  :source => results['line2'],
                  :president => results['president'],
                  :date => Date.parse(result['eventDate'])
      end
      docs
    end
    
    
  end
end