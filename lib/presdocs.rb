%w(document.rb version.rb).each do |f|
  require File.join(File.dirname(__FILE__), 'presdocs/', f)
end