require 'test_helper'

class URLTest < Test::Unit::TestCase

  def setup
    @valid_line = 'Completed in 5ms (View: 4, DB: 1) | 200 OK [http://www.example.com/users/12972]'
    @valid_url = 'http://www.example.com/users/12972'
    @url = Plog::URL.new(@valid_url)
  end

  should 'return a valid url object when instantiated' do
    assert_equal @valid_url, @url.to_s
  end

  should 'simplify correctly' do
    assert_equal '/users/[0-9]', @url.simplify
  end

  should 'simplify removing arguments' do
    @url = Plog::URL.new('http://www.example.com/users/1234?key1=val1&key2=val2')
    assert_equal '/users/[0-9]?', @url.simplify
  end

  should 'hashify correctly' do
    assert_equal '2a5565416b0c92c6c5081342322bf945', @url.hashify
  end

end
