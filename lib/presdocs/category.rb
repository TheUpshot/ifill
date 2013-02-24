module Presdocs
  class Category
    
    attr_reader :name, :count, :children
    
    def self.all
      url = "http://m.gpo.gov/wscpd/mobilecpd/category"
      results = Oj.load(open(url).read)
      create_categories(results['navigatorResults']['Category'])
    end
    
    def self.create_categories(results)
      cats = []
      results.each do |result|
        cats << self.new(:name => result['name'],
                  :count => result['count'],
                  :children => result['children']
      end
      cats
    end
    
  end
end