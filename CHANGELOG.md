# Changelog
## Version 0
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
