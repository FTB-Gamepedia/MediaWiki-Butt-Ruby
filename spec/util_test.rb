require 'minitest/autorun'
require_relative '../lib/mediawiki/utils'
require_relative '../lib/mediawiki/query/query'
require_relative '../lib/mediawiki/butt'

# Do not use this to actually submit requests. Stub them.
MW_BUTT_NO_URL = MediaWiki::Butt.new('http://nonexistentwiki.com/api.php')

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

module MediaWiki
  class Butt
    public :get_limited
    public :validate_namespace
  end
end

describe 'MediaWiki::Query' do
  describe '#get_limited' do
    it 'uses default maximums to limit the value' do
      MW_BUTT_NO_URL.stub(:user_bot?, false) do
        MW_BUTT_NO_URL.get_limited(500).must_equal(500)
        MW_BUTT_NO_URL.get_limited(400).must_equal(400)
        MW_BUTT_NO_URL.get_limited(600).must_equal(500)
      end
    end

    it 'uses custom user maximum values to limit the value' do
      MW_BUTT_NO_URL.stub(:user_bot?, false) do
        MW_BUTT_NO_URL.get_limited(400, 600).must_equal(400)
        MW_BUTT_NO_URL.get_limited(600, 600).must_equal(600)
        MW_BUTT_NO_URL.get_limited(700, 600).must_equal(600)
      end
    end

    it 'limits the value while using a bot account' do
      MW_BUTT_NO_URL.stub(:user_bot?, true) do
        MW_BUTT_NO_URL.get_limited(500).must_equal(500)
        MW_BUTT_NO_URL.get_limited(5000).must_equal(5000)
        MW_BUTT_NO_URL.get_limited(500, 250).must_equal(500)
        MW_BUTT_NO_URL.get_limited(500, 250, 250).must_equal(250)
        MW_BUTT_NO_URL.get_limited(10_000).must_equal(5000)
      end
    end

    it 'uses max as the limit' do
      MW_BUTT_NO_URL.get_limited('max').must_equal('max')
      MW_BUTT_NO_URL.get_limited('MAX').must_equal(500)
      MW_BUTT_NO_URL.get_limited('min').must_equal(500)
    end
  end

  describe '#validate_namespace' do
    it 'Validates the namespaces' do
      MW_BUTT_NO_URL.validate_namespace(0).must_equal(0) # Main/default namespace
      MW_BUTT_NO_URL.validate_namespace(10_000_000).must_equal(0) # Nonexistent namespace
      MW_BUTT_NO_URL.validate_namespace(4).must_equal(4) # Project namespace
    end
  end
end
