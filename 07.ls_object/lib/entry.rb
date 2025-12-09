# frozen_string_literal: true

require 'etc'

class Entry
  def initialize(entry)
    @entry = entry
    entry_information
  end

  def permission_string(mode)
    file_type = case mode & 0o170000
                when 0o040000 then 'd'
                when 0o100000 then '-'
                when 0o120000 then 'l'
                else '?'
                end
    perms = [6, 3, 0].map do |shift|
      bits = (mode >> shift) & 0b111
      [[0b100, 'r'], [0b010, 'w'], [0b001, 'x']].map do |mask, char|
        (bits & mask).zero? ? '-' : char
      end
    end.flatten.join
    file_type + perms
  end

  def entry_information
    stat = File.stat(@entry)
    mode = stat.mode
    link = stat.nlink
    user = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    size = stat.size
    time = stat.mtime.strftime('%b %e %H:%M')
    perm = permission_string(mode)
    name = @entry
    printf "%<perm>s %<link>2d %<user>-8s %<group>-8s %<size>4d %<time>s %<name>s\n",
           perm:,
           link:,
           user:,
           group:,
           size:,
           time:,
           name:
  end
end
