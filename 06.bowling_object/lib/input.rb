class Input
  ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }
end
