# Changelog
## Version 0
### Version 0.3.2
* Update to work with latest version of string-utility.
### Version 0.3.1
* Fix edit and create_page NoMethodErrors.
* Remove dependency for JSON as the version we use is included in the Ruby standard library.

### Version 0.3.0
* New upload method to upload by URL.
* New create_page method.
* New get_userlists method.
* New get_usergroups method.
* New get_contrib_count method.
* Refactor get_usergroups and is_current_user_bot? to use new get_userinfo method.
* Minor refactors to make optional arguments more Ruby-like with splat arguments.
* #edit no longer prints the edit token, because that's stupid.
* #edit no longer sets the summary if it is nil.

### Version 0.2.1
* Fix gemspec. You should actually have the new stuff now.

### Version 0.2.0
* New get_id method to get the pageid from the title.
* New get_random_pages method to get an array of random articles.
* New Namespace module full of constants.
* is_current_user_bot is now called as is_current_user_bot?.
* New get_edit_token method for obtaining an edit token based on the page title.
* New edit method and module for editing pages.
* Fix logout parsing error

### Version 0.1.1
* Got rid of pointless array in is_current_user_bot
* Potentially fixed docs
* Raise errors on unsuccessful account creation
* #login properly returns true if the login is successful on the first try
* #logout returns true/false if it logs the user out. Basically returns true if @logged_in is true, and false if not, because the logout action has no errors.
* Account creation stuff actually returns true/false on success/fail. It also handles errors now.
* Better Category title regex in get_category_members

### Version 0.1.0
* Initial version.
