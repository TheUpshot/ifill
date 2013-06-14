require 'open-uri'
require 'oj'

%w(document.rb category.rb version.rb).each do |f|
  require File.join(File.dirname(__FILE__), 'ifill/', f)
end