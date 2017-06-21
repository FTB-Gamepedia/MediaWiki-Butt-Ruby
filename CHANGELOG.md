# Changelog
## Version 2
### Version 2.0.0
**Breaking changes!**
* Logical reversal of the redirect param for move (#58)
* Switch around type and limit params in `get_category_members` (#57)
* Remove post-install message
* Strip leading and trailing whitespace from username in get_userlists, affecting the following methods (#55):
  * `get_userrights`
  * `get_contrib_count`
  * `get_registration_time`
  * `get_user_gender`
* Change return values of `#upload` to be more useful (#54)
  * `true`/`false` return value denote success/failure
  * `UploadInvalidFileExtError` is raised when the file extension is not valid
  * `EditError` is raised for any errors that occurred during the upload
* New siteinfo methods `get_server`, `get_base_article_path`, and `get_article_path` (#20).
* Modify the `edit`, `create_page`, and `move` methods to take options hashes instead of a bunch of unnamed arguments. (#53, #52)
* Documentation is now stored in master branch

## Version 1
### Version 1.3.0
**Security update!**
* Add support for the Assert API (PR #51).
  * New `:assertion` option in initialize opts. It takes either `:user` or `:bot`.
  * New `override_assertion` parameter in `post` to prevent assertion errors being thrown.
    * **Note**: Assertions will only happen if `post`'s `autoparse` parameter is true.
  * New NotLoggedInError and NotBotError for the according assertions.
  * `Butt#user_bot?` no longer has a parameter. It now queries with an assertion rather than checking the user's groups.
  * New method `Butt#logged_in?` to check if the current instance is logged in.

### Version 1.2.0
* Add support for the Purge API (#48)

### Version 1.1.1
* Fix query methods throwing NoMethodErrors.

### Version 1.1.0
* Support for the continuation API (Issue #9 and PR #47)

### Version 1.0.0
* Important: MediaWiki::Butt now depends on Ruby 2.3. If you aren't using that yet, use it. It's worth it.
* MediaWiki::Butt.new now takes two parameters, `url`, and an options hash. See the documentation for initialize for more details.
* Improvements to the way we handle query limits (#28, #31, and #37):
  * `get_recent_revisions`, `get_prefix_search`, and `get_full_watchlist` now properly set their limits.
  * Most query lists that took a limit parameter now use the attribute `:query_limit_default` instead of each having a set default of 500.
  * New `:query_limit_default` attribute accessor. This means you can change your default limits whenever you want!
  * Support using 'max' as the limit.
* Major cleanup of documentation. The YARD server at ftb-gamepedia.github.io/MediaWiki-Butt-Ruby is now the recommended place for documentation.
* Improve testing slightly.
* Remove the TIME_FORMAT constant and instead use DateTime's methods properly.
* Fix FileRepoInfo methods returning hashes with nil values instead of arrays of hashes (#34).
* Add support for the MediaWiki Watching/Unwatching APIs (#38)
* Remove the unused `:tokens` instance variable. This should silence some errors when logging in/out.
* Improve authentication methods by making them recursive. `login` and `create_account(_email)` now take an optional third parameter, token.
* Fix error in `get_categories_in_page` (APerson241)
* Error handling improvements (APerson241 and elifoster) (#32):
  * New EditError that is thrown when there is an error when editing. It contains the error code.
  * `edit` returns false when there is no change (error: nochange), rather than throwing an error.
  * New BlockError that is thrown when there is an error when blocking/unblocking.
  * Removed AuthenticationError subclasses, as well as `check_login` and `check_create`. All authentication errors now return a generic AuthenticationError with the provided error message from MediaWiki.

## Version 0
### Version 0.11.1
* Relicense under the MIT license.
* Bump HTTPClient dependency.
* Resolve get_registration_time TypeError (#26)

### Version 0.11.0
* Fix get_mostcategories_page typo (Mostca**c**tegories) (#24).
* Significant rewrite of the README, arguably the most important part of this version.
* New Utils module for replicating some of MediaWiki's utilities. Right now this only includes the `#encode_url` method, a Ruby version of the JavaScript method `mw.util.rawurlencode` (#21).
* Recent Changes responses are no longer printed on every request (#19).

### Version 0.10.2
* Update to Ruby 2.3 and HTTPClient 2.7
* All values in Constants, including the keys and values in the NAMESPACES constant, are now frozen objects.

### Version 0.10.1
* Add the accidentally forgotten protect.rb file to the list of files for the gemspec.

### Version 0.10.0
* Remove all incorrectly splatted method arguments, so account creation reasons and edit summaries work now (#12).
* Support a bunch of more Lists (#17). All of the old methods still exist in various submodules. The new methods are:
  * Log:
    * get_interwiki_backlinks
    * get_language_backlinks
    * get_image_backlinks
    * get_url_backlinks
    * get_block_log
    * get_reblock_log
    * get_unblock_log
    * get_delete_log
    * get_deletion_restore_log
    * get_interwiki_import_log
    * get_upload_import_log
    * get_overall_log
    * get_merge_log
    * get_move_log
    * get_move_redirect_log
    * get_autocreate_users_log
    * get_user_create2_log
    * get_user_create2_log
    * get_patrol_log
    * get_modify_protection_log
    * get_move_protected_log
    * get_protect_log
    * get_unprotect_log
    * get_autopromotion_log
    * get_rights_log
    * get_upload_overwrite_log
    * get_upload_log
    * The logs not explicitly supported (they are still supported in get_overall_log) are:
      * upload/revert
      * rights/erevoke
      * delete/event
      * delete/revision
  * Miscellaneous:
    * get_tags
  * QueryPage:
    * get_mostrevisions_page
    * get_mostlinked_page
    * get_mostlinkedtemplates_page
    * get_mostlinkedcategories_page
    * get_mostinterwikis_page
    * get_mostimages_page
    * get_mostlinkedcategories_page
    * get_listduplicatedfiles_page
    * get_listredirects_page
    * get_wantedtemplates_page
    * get_wantedpages_page
    * get_wantedfiles_page
    * get_wantedcategories_page
    * get_unwatchedpages_page
    * get_unusedtemplates_page
    * get_unusedcategories_page
    * get_uncategorizedtemplates_page
    * get_uncategorizedpages_page
    * get_uncategorizedcategories_page
    * get_shortpages_page
    * get_withoutinterwiki_page
    * get_fewestrevisions_page
    * get_lonelypages_page
    * get_ancientpages_page
    * get_longpages_page
    * get_doubleredirects_page
    * get_brokenredirects_page
    * get_querypage
  * RecentChanges:
    * get_recent_changes
    * get_recent_deleted_revisions
  * Search
    * get_prefix_search
* New constant MediaWiki::Constants::TIME_FORMAT for the standard MediaWiki timestamp format.
* Improve performance slightly by using Array#<< instead of Array#push.

### Version 0.9.0
* get_category_members has a new parameter, type, which can be used to get more data in a single result.
* get_category_members no longer gets files and subcategories by default. Use the above to get more data at once.
* New get_subcategories and get_files_in_category for specifically getting files or subcategories.

### Version 0.8.2
* Fix outdated usage of @namespaces variable, causing a NoMethodError on get_random_pages calls.
* Greatly improved documentation.

### Version 0.8.1
* Fix get_limited's NoMethodError on user_bot?
* Fix user_bot? always returning false.

### Version 0.8.0
* A ton of property query methods (#7). View their docs for info:
  * get_all_links_in_page
  * get_other_langs_of_page
  * get_interwiki_links_in_page
  * get_templates_in_page
  * get_images_in_page
  * get_page_size
  * get_protection_levels
  * get_display_title
  * get_number_of_watchers
  * page_new?
  * page_redirect?
  * can_i_read?
  * do_i_watch?
  * get_external_links
  * get_duplicated_files_of
  * get_image_bytes
  * get_image_dimensions
  * get_image_sizes
* A ton of list query methods (#8). View their docs for info:
  * get_all_pages_in_namespace
  * get_all_users
  * get_all_blocks
  * get_all_transcluders
  * get_all_deleted_files
  * get_all_protected_titles
  * get_user_contributions
  * get_full_watchlist
  * get_all_duplicated_files
* Fix a NoMethodError on what_links_here caused by not actually setting the list in that query (#14).
* User-Agents are optionally customizable in the MediaWiki::Butt initialization. If this is not used, the old defaults will still be used ('NotLoggedIn/MediaWiki-Butt' and 'Username/MediaWiki-Butt') (#13).
* Fix @returns in docs.
* Got rid of false things in docs.
* Remove dependency on string-utility. That should be something the user does on their end.
* get_contrib_count no longer has a second parameter, because of the above change.
* Fix open-ended dependency for HTTPClient.
* New get_logged_in_contributors method for getting all logged in user's usernames that have contributed to a page.
* New get_total_contributors method for getting the total number of contributors to a page.
* Refactor Properties to be more like Meta.
* New get_limited protected method that limits the 'limit' parameter for queries. It's essentially just reducing duplicated code.
* Remove all global variables. MediaWiki::Constants::Namespaces' $namespaces is now MediaWiki::Constants with the hash being defined as NAMESPACES (#10).

### Version 0.7.0
* upload's filename argument is no longer splat, because arrays.
* Fix incorrect regex $ when ^ should be used in upload.
* New get_all_categories method.
* New get_all_images method.
* Fix broken user_bot? calls.
* user_bot? returns false when not logged in and username is not set.
* Refactor Query module to have its own folder, and subfolder for meta. This shouldn't change anything on the user's end.
* A couple methods no longer stupidly print stuff.
* New get_categories_in_page method.

### Version 0.6.0
* Slightly expanded Gem description.
* Finished all Meta modules and their methods, except for the allmessages meta query. [#6](https://github.com/ftb-gamepedia/mediawiki-butt-ruby/issues/6)
  * New get_variables method.
  * New get_function_hooks method.
  * New get_extension_tags method.
  * New get_skins method.
  * New get_restriction_levels method.
  * New get_restriction_types method.
  * New get_restrictions_data method for the above methods.
  * New get_allowed_file_extensions method, and refactored #upload to only allow files with those extensions.
  * New get_all_usergroups method.
  * New get_magic_words method.
  * New get_special_page_aliases method.
  * New get_namespace_aliases method.
  * New get_namespaces method.
  * New get_filerepo_favicons method.
  * New get_filerepo_thumburls method.
  * New get_nonlocal_filerepos method.
  * New get_local_filerepos method.
  * New get_filerepo_urls method.
  * New get_filerepo_rooturls method.
  * Refactor get_filerepo_names to use new get_filerepoinfo method.
  * New get_filerepoinfo method, in a similar style to get_userlists.
  * New get_current_user_options for getting a hash containing all of the currently logged in user's preferences.
  * New get_email_address method for getting the currently logged in user's email address.
  * New get_realname method for getting the currently logged in user's real name.
  * New get_changeable_groups method for getting the currently logged in user's groups that they can change (add/remove people from)
  * New current_user_hasmsg? method for checking if the user has any unread messages.
  * check_login no longer returns false, ever, because any code after a fail is unreachable.
  * prop parameter in get_current_user_meta is now optional, for get_current_user_name.
  * New get_current_user_name method, for getting the currently logged in user's username.
  * New get_siteinfo method, in a similar style to get_userlists.
  * New get_statistics method, for getting a hash of the wiki's statistics.
  * New get_general method, for getting hash of the 'general' wiki information.
  * New get_extensions method, for getting an array of all extension names installed.
  * New get_languages method, for getting a hash of all the languages, formatted as code => name.
* User-Agent header is now set for each post. It defaults to `NotLoggedIn/MediaWiki::Butt`, or `#{name}/MediaWiki::Butt` if logged in. This might cause some slight performance issues ([#5](https://github.com/FTB-Gamepedia/MediaWiki-Butt-Ruby/issues/5))

### Version 0.5.0
* New Administration module for administrative methods.
* New block and unblock methods, for (un)blocking users.
* Refactor token stuff. It still doesn't work exactly how I'd like yet, but it's better than it was before. Ideally I'd like to have it get the login-specific tokens on login and set them to some well-named instance variables. Then clear those on logout.
* Single-line each `do end` loops have been converted into `{...}` style loops.
* New delete method for deleting pages.
* New move method for moving pages.

### Version 0.4.1
* params[:format] is now automatically set to 'json', so it no longer needs to be defined in each method.
* Fixed a lot of styling issues thanks to Rubocop.
* check_login and check_create now use case/when statements instead of elsifs.
* check_create no longer returns anything.
* Update minimum Ruby version to 2.1, for refinements.
* Fix $namespaces hash syntax.
* Generally improved if statement syntax.
* Generally shortened a lot of code by using better syntax.

### Version 0.4.0
* New get_userrights method for getting an array of all user rights that user has.
* New get_user_gender method for getting the gender of the provided user.
* New get_current_user_meta for getting userlists about the currently logged in user. Essentially the equivalent of get_userlists for logged in users.
* Fix all userlist methods to work without supplying a username.
* New get_registration_time method to get when the user registered.
* Update to work with latest version of string-utility.
* Namespaces are now in a hash instead of a bunch of variables.
* Namespace parameters are now actually limited to the valid namespaces constant. It will default to the main namespace (0) if the integer provided is not in the namespaces hash.
* get_random_pages no longer wrongly sets the rnlimit to the namespaces argument rather than the namespace argument.

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
* `#edit` no longer prints the edit token, because that's stupid.
* `#edit` no longer sets the summary if it is nil.

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
* `#login` properly returns true if the login is successful on the first try
* `#logout` returns true/false if it logs the user out. Basically returns true if @logged_in is true, and false if not, because the logout action has no errors.
* Account creation stuff actually returns true/false on success/fail. It also handles errors now.
* Better Category title regex in get_category_members

### Version 0.1.0
* Initial version.
