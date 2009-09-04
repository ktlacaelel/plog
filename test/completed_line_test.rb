require 'test_helper'

class CompletedLineTest < Test::Unit::TestCase

  def setup
    @valid_first_fragment = 'Completed in 5ms (View: 4, DB: 1) '
    @valid_line = 'Completed in 5ms (View: 4, DB: 1) | 200 OK [http://www.example.com/users/12972]'
    @valid_line_no_view = 'Completed in 5ms (DB: 5) | 200 OK [http://www.example.com/users/12972]'
    @valid_second_fragment = ' 200 OK [http://www.example.com/users/12972]'

    @valid_db_time = 1
    @valid_view_time = 4
    @valid_total_time = 5

    @valid_db_time_no_view = 5
    @valid_view_time_no_view = 0
    @valid_total_time_no_view = 5

    @valid_csv_line = '5,4,1,/users/[0-9]'
    @valid_status_string = 'OK'
    @valid_status_number = '200'
  end

  # ============================================================================
  # READ
  # ============================================================================

  should 'read a valid completed line (standard)' do
    Plog::CompletedLine.read! @valid_line
    assert_equal @valid_view_time, Plog::CompletedLine.view_time
    assert_equal @valid_db_time, Plog::CompletedLine.db_time
    assert_equal @valid_total_time, Plog::CompletedLine.total_time
  end

  should 'read valid completed line (without view time)' do
    Plog::CompletedLine.read! @valid_line_no_view
    assert_equal 5, Plog::CompletedLine.total_time
    assert_equal 0, Plog::CompletedLine.view_time
    assert_equal 5, Plog::CompletedLine.db_time
  end

  # ============================================================================
  # RECALCULATION
  # ============================================================================

  should 'recalculate acurately!' do
    Plog::CompletedLine.read! @valid_line
    Plog::CompletedLine.merge(1, 1)
    assert_equal (@valid_view_time + 1), Plog::CompletedLine.view_time
    assert_equal (@valid_db_time + 1), Plog::CompletedLine.db_time
    assert_equal (@valid_total_time + 2), Plog::CompletedLine.total_time
  end

  # ============================================================================
  # FRAGMENTATION
  # ============================================================================

  should 'fragmentize correctly' do
    Plog::CompletedLine.read! @valid_line
    first, second = Plog::CompletedLine.fragmentize!
    assert_equal @valid_first_fragment, first
    assert_equal @valid_second_fragment, second
  end

  # ============================================================================
  # TIME RETRIVAL ( when view & db are *both* present )
  # ============================================================================

  should 'retrive correct total time (view + db)' do
    Plog::CompletedLine.read! @valid_line
    assert_equal @valid_total_time, Plog::CompletedLine.total_time
  end

  should 'retrive correct view time (view + db)' do
    Plog::CompletedLine.read! @valid_line
    assert_equal @valid_view_time, Plog::CompletedLine.view_time
  end

  should 'retrive correct db time (view + db)' do
    Plog::CompletedLine.read! @valid_line
    assert_equal @valid_db_time, Plog::CompletedLine.db_time
  end

  # ============================================================================
  # TIME RETRIVAL ( when only db time is present )
  # ============================================================================

  should 'retrive correct total time (only db)' do
    Plog::CompletedLine.read! @valid_line_no_view
    assert_equal @valid_total_time_no_view, Plog::CompletedLine.total_time
  end

  should 'retrive correct view time (only db)' do
    Plog::CompletedLine.read! @valid_line_no_view
    assert_equal @valid_view_time_no_view, Plog::CompletedLine.view_time
  end

  should 'retrive correct db time (only db)' do
    Plog::CompletedLine.read! @valid_line_no_view
    assert_equal @valid_db_time_no_view, Plog::CompletedLine.db_time
  end

  # ============================================================================
  # CSV COMPILATION
  # ============================================================================

  should 'export to csv' do
    Plog::CompletedLine.read! @valid_line
    assert_equal @valid_csv_line, Plog::CompletedLine.to_csv
  end

  # ============================================================================
  # COMPLETED LINE DETECTION
  # ============================================================================

  should 'ignore *NON* completed lines' do
    Plog::CompletedLine.read! 'completed'
    assert_equal false, Plog::CompletedLine.completed_line?

    Plog::CompletedLine.read! 'Completed'
    assert_equal false, Plog::CompletedLine.completed_line?

    Plog::CompletedLine.read! 'Completed Completed  Completed Completed'
    assert_equal false, Plog::CompletedLine.completed_line?

    Plog::CompletedLine.read! 'aalsdjflasdjflsa dflksjdflkasjdf lfCompleted'
    assert_equal false, Plog::CompletedLine.completed_line?

    Plog::CompletedLine.read! nil
    assert_equal false, Plog::CompletedLine.completed_line?

    Plog::CompletedLine.read! false
    assert_equal false, Plog::CompletedLine.completed_line?

    Plog::CompletedLine.read! 0
    assert_equal false, Plog::CompletedLine.completed_line?

    Plog::CompletedLine.read!  ''
    assert_equal false, Plog::CompletedLine.completed_line?
  end

  # ============================================================================
  # STATUS EXTRACTION
  # ============================================================================

  should 'extract status string' do
    Plog::CompletedLine.read! @valid_line
    assert_equal @valid_status_string, Plog::CompletedLine.status_string
  end

  should 'extract status number' do
    Plog::CompletedLine.read! @valid_line
    assert_equal @valid_status_number, Plog::CompletedLine.status_number
  end

end
