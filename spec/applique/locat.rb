require 'locat'
require 'fileutils'

When 'Given an example ruby project' do
  FileUtils.rm 'locat.html' if File.exist?('locat.html')
  FileUtils.cp_r(File.dirname(__FILE__) + '/../fixtures/.', '.')
end

When 'with a `.locat` file' do |text|
  File.open('.locat', 'w'){ |f| f << text }
end

