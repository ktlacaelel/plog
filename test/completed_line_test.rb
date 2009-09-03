require 'test_helper'

class CompletedLineTest < Test::Unit::TestCase

  def setup
    @valid_line = 'Completed in 5ms (View: 4, DB: 1) | 200 OK [http://www.example.com/users/12972]'
    @valid_db_time = 1
    @valid_view_time = 4
    @valid_total_time = 5
  end

  def teardown
    @valid_line = nil
  end

  should 'read a valid completed line' do
    Plog::CompletedLine.read! @valid_line
    assert_equal @valid_view_time, Plog::CompletedLine.view_time
    assert_equal @valid_db_time, Plog::CompletedLine.db_time
    assert_equal @valid_total_time, Plog::CompletedLine.total_time
  end

end
