module MediaWiki
  class Butt
    class AuthenticationError < StandardError; end
    class EditError < StandardError; end
    class BlockError < StandardError; end
    class NotLoggedInError < StandardError; end
    class NotBotError < StandardError; end
    class UploadInvalidFileExtError < StandardError; end
  end
end
