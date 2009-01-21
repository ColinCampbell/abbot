require File.expand_path(File.join(File.dirname(__FILE__), 'base'))
require 'fileutils'

module SC

  # This builder is used to generate a file containing all of the loc strings
  # for a particular manifest.  The strings file is used when generating 
  # HTML try to map localized strings
  class Builder::Strings < Builder::Base
    
    def build(dst_path)
      data = parse_strings_js(entry.source_path)
      writelines dst_path, [data.to_yaml]
    end
    
    def parse_strings_js(source_path)
      return {} if !File.exists?(source_path)

      # read the file in and strip out comments...
      str = File.read(source_path)
      str = str.gsub(/\/\/.*$/,'').gsub(/\/\*.*\*\//m,'')

      # Now build the hash
      ret = {}
      str.scan(/['"](.+)['"]\s*:\s*['"](.+)['"],?\s*$/) do |x,y|
        # x & y are JS strings that must be evaled as such..
        #x = eval(%("#{x}"))
        y = eval(%[<<__EOF__\n#{y}\n__EOF__]).chop
        ret[x] = y
      end
      return ret 
    end
      
    
  end
  
end
