module MediaWiki
  class Butt
    class AuthenticationError < StandardError; end

    class NeedTokenMoreThanOnceError < AuthenticationError
      def message
        'You tried to get the token more than once. You likely have some' \
        'problem with your login call.'
      end
    end

    class NoNameError < AuthenticationError
      def message
        'You did not set the lgname parameter.'
      end
    end

    class IllegalUsernameError < AuthenticationError
      def message
        'You provided an illegal username.'
      end
    end

    class UsernameNotExistsError < AuthenticationError
      def message
        'You provided a username that does not exist.'
      end
    end

    class EmptyPassError < AuthenticationError
      def message
        'You did not set the lgpassword paremeter.'
      end
    end

    class WrongPassError < AuthenticationError
      def message
        'The password you provided is not correct.'
      end
    end

    class WrongPluginPassError < AuthenticationError
      def message
        'A plugin (not MediaWiki) claims your password is not correct.'
      end
    end

    class CreateBlockedError < AuthenticationError
      def message
        'MediaWiki tried to automatically create an account for you, but your' \
        'IP is blocked from account creation.'
      end
    end

    class ThrottledError < AuthenticationError
      def message
        'You\'ve logged in too many times.'
      end
    end

    class BlockedError < AuthenticationError
      def message
        'User is blocked.'
      end
    end

    # Start creation-specific errors
    class UserExistsError < AuthenticationError
      def message
        'Username entered is already in use.'
      end
    end

    class UserPassMatchError < AuthenticationError
      def message
        'Your password must be different from your username.'
      end
    end

    class PasswordLoginForbiddenError < AuthenticationError
      def message
        'The use of this username and password has been forbidden.'
      end
    end

    class NoEmailTitleError < AuthenticationError
      def message
        'No email address.'
      end
    end

    class InvalidEmailAddressError < AuthenticationError
      def message
        'The email address is invalid.'
      end
    end

    class PasswordTooShortError < AuthenticationError
      def message
        'The password was shorter than the value of $wgMinimalPasswordLength'
      end
    end

    class NoEmailError < AuthenticationError
      def message
        'There is no email address recorded for the user.'
      end
    end

    class AbortedError < AuthenticationError
      def message
        'Aborted by an extension.'
      end
    end

    class PermDeniedError < AuthenticationError
      def message
        'You do not have the right to make an account.'
      end
    end

    class HookAbortedError < AuthenticationError
      def message
        'An extension aborted the account creation.'
      end
    end
  end
end
