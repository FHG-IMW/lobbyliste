# Lobbyliste

This gem crawls and parses the the list of lobbyists which is published as a PDF by the German Bundestag.
It provides a simple interface to the parsed data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lobbyliste'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lobbyliste

*NOTE: This gem requires JAVA to be installed. We use [PDFBox](https://pdfbox.apache.org/)   for PDF extraction as this currently seems to be the best alternative for pdf to tex extraction*

## Usage

```ruby
require 'lobbyliste'

list = Lobbyliste.fetch_and_parse
organisation = list.organisations.first

organisation.name #=> 1219. Deutsche Stiftung für interreligiösen und interkulturellen Dialog e. V.

organisation.people.map {|person| person.name} #=> ["Claudius Groß", "Markus Hoymann", "Thomas M. Schimmel"]

organisation.tags #=> ["Kultur", "Religion"]

address = organisation.name_and_address
puts address.full_address
#1219. Deutsche Stiftung für interreligiösen und #interkulturellen Dialog e. V.
#Hinter der katholischen Kirche 3
#10117 Berlin
#Deutschland
#Tel: +4930 51057773
#Fax: +4930 51057785
#Email: schimmel@1219.eu
#http://www.1219.eu
```



# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lobbyliste. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
