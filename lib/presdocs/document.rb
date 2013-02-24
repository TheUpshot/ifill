module Presdocs
  class Document
    
    attr_reader :location, :title, :source, :president, :date, :package_id, :lat, :lng, :subjects, :category, :notes, :fdsys_url, :html
   
    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
    end
    
    def self.detail(package_id)
      url = "http://m.gpo.gov/wscpd/mobilecpd/detailwgc/#{package_id}.json"
      result = Oj.load(open(url).read)
      create_document(result, full=true)
    end
    
    def self.latest
      url = "http://m.gpo.gov/wscpd/mobilecpd/home.json"
      results = Oj.load(open(url).read)
      create_from_search_results(results['searchResults'], nil)
    end
    
    def self.with_locations
      url = "http://m.gpo.gov/wscpd/mobilecpd/location.json"
      results = Oj.load(open(url).read)
      create_from_search_results(results['searchResults'], results['coordinates'])
    end
    
    def self.create_from_search_results(results, coordinates)
      docs = []
      results.each do |result|
        city, state = result['location'].split(', ')
        if coordinates
          locations = coordinates.map{|l| {"state" => l['state'], "city" => l['city'], "lat" => l["lat"], "lng" => l["lang"]}}.uniq
          lat = locations.detect{|l| l['city'] == city && l['state'] == state}['lat']
          lng = locations.detect{|l| l['city'] == city && l['state'] == state}['lng']
        end
        docs << create_document(result)
      end
      docs
    end
    
    def self.create_document(result, full=false)
      if full
        detail = result
        result = result['searchResults']
      end
      doc = self.new(:id => result['packageId'],
                :city => city,
                :state => state,
                :lat => lat,
                :lng => lng,
                :title => result['line1'],
                :source => result['line2'],
                :president => result['president'],
                :date => Date.parse(result['eventDate']))
      
      if full
        h = {:category => detail['category'], :notes => detail['notes'], :subjects => detail['subject'], :fdsys_url => detail['fdsysUrl'], :html => detail['fullText']}
        doc.merge(h)
      end
      doc
    end
  end
end