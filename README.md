# LOCat

{Homepage}[http://rubyworks.github.com/locat] |
{Development}[http://github.com/rubyworks/locat] |
{Issue Tracker}[http://github.com/rubyworks/locat/issues] |
{Mailing List}[http://groups.google.com/group/rubyworks-mailinglist]

{<img src="http://travis-ci.org/rubyworks/locat.png" />}[http://travis-ci.org/rubyworks/locat]


## DESCRIPTION

LOCat is a fancy Lines-Of-Code analysis tool.


## SYNOPSIS

Define a `.locat` Ruby script in your project, e.g.

    match 'lib/**.rb' do |file, line|
      case line
      when /^\s*#/
        'Comment'
      when /^\s*$/
        'Blank'
      else
        'Code'
      end
    end

    match 'test/**.rb' do |file, line|
      case line
      when /^\s*#/
        'Comment'
      when /^\s*$/
        'Blank'
      else
        'Test'
      end
    end

Then run `locat`, e.g.

    $ locat -o locat.html


## COPYRIGHT

Copyright (c) 2011 Rubyworks

BSD 2-Clause License

See LICENSE.md for details.

