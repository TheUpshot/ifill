module Presdocs
  class Document
    
    attr_reader :id, :location, :title, :source, :president, :date, :package_id, :lat, :lng, :subjects, :category, :notes, :fdsys_url, :html, :city, :state
   
    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
    end
    
    def add_attributes(params)
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
    end

    def detail
      Document.detail(id)
    end
    
    def self.detail(package_id)
      url = "http://m.gpo.gov/wscpd/mobilecpd/detailwgc/#{package_id}.json"
      result = Oj.load(open(url).read)
      create_document(result, nil, full=true)
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

    def self.city(city, state)
      url = "http://m.gpo.gov/wscpd/mobilecpd/location/#{city}/#{state}.json"
      results = Oj.load(open(url).read)
      create_from_search_results(results['searchResults'], results['coordinates'])
    end
    
    def self.state(state)
      url = "http://m.gpo.gov/wscpd/mobilecpd/location/#{state}.json"
      results = Oj.load(open(url).read)
      create_from_search_results(results['searchResults'], results['coordinates'])
    end
    
    def self.location_with_distance(lat, lng, distance)
      url = "http://m.gpo.gov/wscpd/mobilecpd/location/#{lat}/#{lng}/#{distance}.json"
      results = Oj.load(open(url).read)
      create_from_search_results(results['searchResults'], results['coordinates'])
    end
    
    def self.date(date)
      d = process_date(date)
      url = "http://m.gpo.gov/wscpd/mobilecpd/date/#{d}.json"
      results = Oj.load(open(url).read)
      create_from_search_results(results['searchResults'], nil)
    end
    
    def self.date_range(start_date, end_date)
      s = process_date(start_date)
      e = process_date(end_date)
      url = "http://m.gpo.gov/wscpd/mobilecpd/date/#{s}/#{e}.json"
      results = Oj.load(open(url).read)
      create_from_search_results(results['searchResults'], nil)
    end
    
    def self.category(category)
      url = "http://m.gpo.gov/wscpd/mobilecpd/category/#{category}.json"
      results = Oj.load(open(url).read)
      create_from_search_results(results['searchResults'], nil)
    end
    
    def self.process_date(date)
      begin
        if date.is_a?(Date)
          d = date.strftime("%-m-%-d-%Y")
        else
          d = Date.strptime(date, '%m/%d/%Y').strftime("%-m-%-d-%Y")
        end
      rescue
        raise "Dates must be Ruby Date objects or a Date string such as '2/14/2013'"
      end
    end
    
    def self.create_from_search_results(results, coordinates)
      docs = []
      results.each do |result|
        docs << create_document(result, coordinates)
      end
      docs
    end
    
    def self.create_document(result, coordinates, full=false)
      if full
        detail = result
        result = result['searchResult']
      end
      city, state = result['location'].split(', ')
      if coordinates
        locations = coordinates.map{|l| {"state" => l['state'], "city" => l['city'], "lat" => l["lat"], "lng" => l["lang"]}}.uniq
        lat = locations.detect{|l| l['city'] == city && l['state'] == state}['lat']
        lng = locations.detect{|l| l['city'] == city && l['state'] == state}['lng']
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
        h = {:category => detail['category'], :notes => detail['notes'], :subjects => detail['subject'].map{|s| s.strip}.reject!(&:empty?), :fdsys_url => detail['fdsysUrl'], :html => detail['fullText']}
        doc.add_attributes(h)
      end
      doc
    end
  end
end
