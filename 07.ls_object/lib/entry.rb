# frozen_string_literal: true

class Entry
  # パーミッション、所有者、サイズ、更新日時の情報を返せる
  # def initialize
  #   entry_information
  # end

  # private
  # def entry_information
  #   files.each do |file|
  #     stat = File.stat(file)
  #     mode = stat.mode
  #     link = stat.nlink
  #     user = Etc.getpwuid(stat.uid).name
  #     group = Etc.getgrgid(stat.gid).name
  #     size = stat.size
  #     time = stat.mtime.strftime('%b %e %H:%M')
  #     perm = permission_string(mode)
  #     name = file
  # end
end
