require 'minitest/autorun'
require_relative '../lib/mediawiki/utils'

def test_encode_url(base, result)
  url = MediaWiki::Utils.encode_url(base)
  url.must_be_instance_of(String)
  url.wont_be_nil
  url.wont_be_empty
  url.must_equal(result)
end

describe 'MediaWiki::Utils' do
  it 'encodes the URL like mw.util.rawurlencode' do
    test_encode_url('!', '%21')
    test_encode_url('abc', 'abc')
    test_encode_url("'", '%27')
    test_encode_url('(', '%28')
    test_encode_url(')', '%29')
    test_encode_url('*', '%2A')
    test_encode_url('~', '%7E')
    test_encode_url("*~This~* is a 'test'! (sorry for yelling)",
                    '%2A%7EThis%7E%2A is a %27test%27%21 %28sorry for yelling%29')
  end
end