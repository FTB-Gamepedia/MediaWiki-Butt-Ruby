# MediaWiki::Butt
[![Gem Version](https://badge.fury.io/rb/mediawiki-butt.svg)](https://badge.fury.io/rb/mediawiki-butt)
[![Build Status](https://travis-ci.org/FTB-Gamepedia/MediaWiki-Butt-Ruby.svg?branch=master)](https://travis-ci.org/FTB-Gamepedia/MediaWiki-Butt-Ruby)


A Ruby library for the MediaWiki API.

## Why?
Two of the main editors at the FTB Gamepedia site found that the lack of functional Ruby Gems for MediaWiki API interactions made it difficult to interact with the wiki through IRC bots ([ESAEBSAD](https://github.com/xbony2/Experimental-Self-Aware-Electronic-Based-Space-Analyzing-Droid) and [SatanicBot](https://github.com/FTB-Gamepedia/SatanicBot)) and scripts. Some core features were either missing entirely or severely out of date in the many other MediaWiki gems, such as basic queries needed for everyday-actions like getting page contents and page backlinks.

MediaWiki::Butt actually began as two local libraries that @xbony2 and @elifoster, the two developers of this gem, worked on separately in their own IRC bot repositories, called `wikiutils`. This was an extremely basic API interface for pretty much only queries, with no authentication. Eventually, however, using two or three separate libraries for various API actions grew tiresome, and thus, Butt was born!

## Basic feature overview
Pretty much every API action in core MediaWiki is possible through a helper instance method. However, for things that are not supported, there is the `post` method, which submits a `POST` request (which works fine for things that require a `GET` request in the API), that takes a hash parameter to pass to the API. Through this helper method, any API can be accessed!

## Limitations
There is currently no extension support. Some APIs are also not supported because the majority of the testing occurs on Gamepedia, which often uses software that is not always up to date.

## Installation
### RubyGems
```shell
$ gem install mediawiki-butt
```

### Bundler
Add this line to application's Gemfile:

```ruby
gem('mediawiki-butt')
```

And then execute:

```shell
$ bundle
```

## Documentation
Documentation can be found [here](http://ftb-gamepedia.github.io/MediaWiki-Butt-Ruby).

## Quick start
To get the text of the main page:
```ruby
require 'mediawiki/butt'
wiki = MediaWiki::Butt.new('https://en.wikipedia.org/w/api.php')
wiki.login(username, password)
main_page_text = wiki.get_text('Main Page')
```
