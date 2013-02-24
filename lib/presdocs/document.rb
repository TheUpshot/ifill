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
      create_documents(results['searchResults'], nil)
    end
    
    def self.with_locations
      url = "http://m.gpo.gov/wscpd/mobilecpd/location"
      results = Oj.load(open(url).read)
      create_documents(results['searchResults'], results['coordinates'])
    end
    
    def self.create_documents(results, coordinates)
      docs = []
      results.each do |result|
        locations = coordinates.map{|l| {"state" => l['state'], "city" => l['city'], "lat" => l["lat"], "lng" => l["lang"]}}.uniq if coordinates
        city, state = result['location'].split(', ')
        lat = locations.detect{|l| l['city'] == city && l['state'] == state}['lat']
        lng = locations.detect{|l| l['city'] == city && l['state'] == state}['lng']
        docs << self.new(:id => result['packageId'],
                  :city => city,
                  :state => state,
                  :lat => lat,
                  :lng => lng,
                  :title => result['line1'],
                  :source => result['line2'],
                  :president => result['president'],
                  :date => Date.parse(result['eventDate']))
      end
      docs
    end
    
  end
end