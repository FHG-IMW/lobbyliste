# Lobbyliste

This gem crawls and parses the the list of lobbyists which is published as a PDF by the German Bundestag.
Our goal is to provide a simple and easy to maintain parser.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lobbyliste'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lobbyliste

*NOTE: This gem requires JAVA to be installed. We use [PDFBox](https://pdfbox.apache.org/) for PDF extraction as this currently seems to be the best alternative*

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
# 1219. Deutsche Stiftung für interreligiösen und #interkulturellen Dialog e. V.
# Hinter der katholischen Kirche 3
# 10117 Berlin
# Deutschland
# Tel: +4930 51057773
# Fax: +4930 51057785
# Email: schimmel@1219.eu
# http://www.1219.eu
```

### CLI

You can also use this gem on your comandline. It will dump the complete list as JSON

For example to create a gziped json file run:

```bash
$ lobbyliste | gzip > lobbyliste.json.gz 
```


# Special Thanks

- [Sebastian Vollnhals (@yetzt)](https://github.com/yetzt) - for his excellent node based scraper for the lobbyliste (https://github.com/yetzt/scraper-lobbyliste) from which many lines were reused.

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lobbyliste. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
