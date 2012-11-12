
# Returns the contents of a file and
# decrypts it with GPG if possible

module Puppet::Parser::Functions
  newfunction(:decrypt_file, :type => :rvalue,
              :doc => "Returns the contents of a file. .gpg or .asc files are decrypted using GnuPG."
              ) do |vals|
    ret = nil
    file = vals[0]
    unless Puppet::Util.absolute_path?(file)
      raise Puppet::ParseError, "Files must be fully qualified"
    end
    # test for encryption:
    # gpg --quiet --status-fd 1 --list-only -d  file
    if FileTest.exists?(file)
      
      if file =~ /\.(asc|gpg)$/
        
        ret = %x(gpg -d #{file})        
        if $?.exitstatus==0
          ret
        else
          raise Puppet::ParseError, "GPG decrypt failed for #{vals.join(", ")}"
        end
        
       else
        File.read(file)
      end
      
    else
      raise Puppet::ParseError, "File does not exists #{file}"
    end
  end
end
