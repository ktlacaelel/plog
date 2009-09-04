require 'test_helper'

class LogFileTest < Test::Unit::TestCase

  def setup
    @log_file = 'test/data/example.log'
    @file = Plog::LogFile.new(@log_file)
    @object_hash = 'a1e0e00d04e82bdf0f1ac151de03591c'
    @object_path = 'objects/' + @object_hash
    @final_csv_result = '10,70,40,30,/users/[0-9]'
    @default_object_path = 'objects/2a5565416b0c92c6c5081342322bf945'
  end

  def teardown
    @file.close
  end

  should 'generate an appropriate object_path' do
    assert_equal @default_object_path, @file.object_path
  end

  def whipe_out_objects_dir
    Dir.glob('./objects/*').each do |file|
      FileUtils.rm_r(file, :force => true)
    end
    FileUtils.rmdir './objects'
  end

  should 'parse data appropriately' do
    whipe_out_objects_dir
    @file = Plog::LogFile.new(@log_file)
    @file.parse_completed_lines!
    assert_equal @final_csv_result, File.new(@object_path).read.chomp
  end

end
