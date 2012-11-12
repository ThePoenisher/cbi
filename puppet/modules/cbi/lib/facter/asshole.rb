#File.open("/etc/passwd", "r") do |infile|
#  while (line = infile.gets)
File.read('/etc/passwd').each_line do |line|
  line =~ /^([^:]*)/
  Facter.add("user_info_#{$1}") do
    setcode do
      line
    end
  end
  #{line}"
end
