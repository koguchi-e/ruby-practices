# frozen_string_literal: true

require 'etc'

class FileMetadata
  def initialize(file_entry)
    @file_entry = file_entry
    @stat = File.stat(@file_entry)
  end

  def mode
    @stat.mode
  end

  def link
    @stat.nlink
  end

  def user_name
    Etc.getpwuid(@stat.uid).name
  end

  def user_group
    Etc.getgrgid(@stat.gid).name
  end

  def file_size
    @stat.size
  end

  def time_stamp
    @stat.mtime
  end

  def name
    File.basename(@file_entry)
  end
end
