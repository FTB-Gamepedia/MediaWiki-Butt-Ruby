# MediaWiki::Butt
A Ruby library for the MediaWiki API

This gem is currently limited in features, but is actively developed.

## Why you should use this gem over others
This gem is very easy to use, with adaptability to the user's needs.

Some other gems have methods that do not work at all, but are critical to using a Wiki, such as getting wiki text and getting page's backlinks.

## Installation
```
gem install mediawiki-butt
```

## Features
Has support for the following MediaWiki API features:
* Query
  * List
    * Category members
    * Backlinks
  * Properties
    * Wiki text
  * Meta
    * File repository name
* Authentication
  * Login
  * Logout
  * Create account
    * With support for emailing random password to the user.
