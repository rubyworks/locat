if defined?(Encoding)
  Encoding.default_external = Encoding::UTF_8
end

module LOCat

  require 'json'
  require 'optparse'
  require 'fileutils'
  require 'erb'

  require 'locat/matcher'
  require 'locat/counter'
  require 'locat/template'
  require 'locat/gitloc'
  require 'locat/command'

end
