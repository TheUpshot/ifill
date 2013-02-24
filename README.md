# Presdocs: A Ruby wrapper for the Compilation of Presidential Documents

The White House releases a lot of stuff, and some of it is included in what's known as the [Compilation of Presidential Documents](http://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD). This is a Ruby library for accessing details about those documents, including subjects, dates, locations and more.

## Installation

Add this line to your application's Gemfile:

    gem 'presdocs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install presdocs

## Usage

    require 'rubygems'
    require 'presdocs'
    include Presdocs
    
    @latest_docs = Document.latest
    
More documentation coming soon. Check the tests, too.

## Test

Presdocs uses minitest and is tested under Ruby 1.9.3; to run the tests:
  
    rake test

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

