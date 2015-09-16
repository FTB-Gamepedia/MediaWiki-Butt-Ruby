module MediaWiki
  class Butt
    class AuthenticationError < StandardError; end

    class NeedTokenMoreThanOnceError < AuthenticationError
      def message
        "You tried to get the token more than once. You likely have some problem with your login call."
      end
    end

    class NoNameError < AuthenticationError
      def message
        "You did not set the lgname parameter."
      end
    end

    class IllegalUsernameError < AuthenticationError
      def message
        "You provided an illegal username."
      end
    end

    class UsernameNotExistsError < AuthenticationError
      def message
        "You provided a username that does not exist."
      end
    end

    class EmptyPassError < AuthenticationError
      def message
        "You did not set the lgpassword paremeter."
      end
    end

    class WrongPassError < AuthenticationError
      def message
        "The password you provided is not correct."
      end
    end

    class WrongPluginPassError < AuthenticationError
      def message
        "A plugin (not MediaWiki) claims your password is not correct."
      end
    end

    class CreateBlockedError < AuthenticationError
      def message
        "MediaWiki tried to automatically create an account for you, but your IP is blocked from account creation."
      end
    end

    class ThrottledError < AuthenticationError
      def message
        "You've logged in too many times."
      end
    end

    class BlockedError < AuthenticationError
      def message
        "User is blocked."
      end
    end
  end
end
