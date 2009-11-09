require 'test_helper'

class ObjectFileTest < Test::Unit::TestCase

  def setup
    @testing_filename = 'kazu.test'
    @file = Plog::ObjectFile.new(@testing_filename, 'w+')
    @default_serialized_data = '0,0,0,0,default'

    @changed_hits = 1
    @changed_total_time = 2
    @changed_view_time = 3
    @changed_db_time = 4
    @changed_simplified_url = 'http://example.com'
    @changed_serialized_data = '1,2,3,4,http://example.com'
    @changed_serialized_data_twice = '2,4,6,8,http://example.com'

    @export_data = '1              0.002          0.002          0.004          0.004          0.003          0.003          http://example.com                      '
  end

  def teardown
    @file.close unless @skip_close
  end

  should 'load default values on initialization' do
    assert_equal 'default', @file.simplified_url
    assert_equal 0, @file.view_time
    assert_equal 0, @file.db_time
    assert_equal 0, @file.total_time
    assert_equal 0, @file.total_hits
  end

  should 'serialize changes correctly' do
    assert_equal @default_serialized_data, @file.serialize_changes
  end

  # ============================================================================
  # DATA APPENDING
  # ============================================================================

  should 'increment view time correctly' do
    @file.append_view_time 500
    assert_equal 500, @file.view_time
    @file.append_view_time 500
    assert_equal 1000, @file.view_time
  end

  should 'increment db time correctly' do
    @file.append_db_time 500
    assert_equal 500, @file.db_time
    @file.append_db_time 500
    assert_equal 1000, @file.db_time
  end

  should 'increment total time correctly' do
    @file.append_total_time 500
    assert_equal 500, @file.total_time
    @file.append_total_time 500
    assert_equal 1000, @file.total_time
  end

  should 'increment hits count correctly' do
    @file.append_hits 500
    assert_equal 500, @file.total_hits
    @file.append_hits 500
    assert_equal 1000, @file.total_hits
  end

  # ============================================================================
  # DATA STORAGE
  # ============================================================================

  should 'store default data correctly if nothing is given' do
    @file.save_changes!
    @file.close
    @skip_close = true
    stored_data = File.new(@testing_filename).read.chomp
    assert_equal @default_serialized_data, stored_data
  end

  def alter_data
    @file.append_hits @changed_hits
    @file.append_db_time @changed_db_time
    @file.append_view_time @changed_view_time
    @file.append_total_time @changed_total_time
    @file.simplified_url = @changed_simplified_url
  end

  # ============================================================================
  # DATA LOADING
  # ============================================================================

  should 'store altered data & retrive correctly' do
    alter_data
    @file.save_changes!
    @file.close
    @skip_close = true

    @file = Plog::ObjectFile.new(@testing_filename, 'w+')
    assert_equal @changed_total_time, @file.total_time, 'total'
    assert_equal @changed_view_time, @file.view_time, 'view'
    assert_equal @changed_db_time, @file.db_time, 'db'
    assert_equal @changed_hits, @file.total_hits, 'hits'
  end

  # ============================================================================
  # DATA EXPORTS
  # ============================================================================

  should 'export data correctly' do
    alter_data
    assert_equal @export_data, @file.export
  end

end
