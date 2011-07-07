module LOCat

  require 'json'
  require 'optparse'
  require 'fileutils'
  require 'erb'

  require 'locat/gitloc'

  #
  def self.cli(*argv)
    options = {:files=>nil, :output=>nil}

    OptionParser.new do |opt|
      opt.on('--template', '-t [NAME]', 'template') do |template|
        options[:template] = template
      end
      opt.on('--output', '-o [FILE]', 'output file') do |output|
        options[:output] = output
      end
      opt.on('--debug',  '-D', 'run in debug mode') do
        $DEBUG = true
      end
      opt.on('--help',   '-h', 'display this help message') do
        puts opt
        exit 0
      end
    end.parse(argv)

    options[:files] = argv
   
    command = Command.new(options)
    command.run
  end

  #
  class Command

    def initialize(options)
      @files    = nil
      @output   = nil
      @template = 'highchart'

      options.each do |k,v|
        send("#{k}=", v)
      end
    end

    #
    attr_accessor :files

    #
    attr_accessor :template

    #
    attr_reader :output

    #
    def output=(file)
      @output = file
    end

    #
    def run
      save
    end

   private

    def counter
      @counter ||= Counter.new(:files=>files)
    end

    # Save.
    def save
      if template == 'json'
        json = counter.to_json
        save_file(json)
      elsif template == 'gitloc'
        gitloc = GitLOC.new
        save_file(gitloc.generate)
      else
        template_file = File.join(template_dir, template + '.rhtml')
        template = ERB.new(File.read(template_file))
        html = template.result(counter.__binding__)
        save_file(html)
      end
    end

    #
    def save_file(text)
      if output
        File.open(File.join(output), 'w') do |f|
          f << text
        end
      else
        puts text
      end
    end

    #
    def template_dir
      File.dirname(__FILE__) + '/locat/template'
    end

  end

  #
  class Counter

    def initialize(options)
      options.each do |k,v|
        send("#{k}=", v)
      end
    end

    #
    def config_file
      Dir['.locat'].first
    end

    #
    def config
      @config ||= Config.new(config_file)
    end

    #
    def files
      @files
    end

    #
    def files=(files)
      @files = files.map{ |f| Dir[f] }.flatten
    end

    # Resolve file glob.
    def resolve_files(glob)
      if File.directory?(glob)
        glob = File.join(glob, '**', '*')
      end
      if files.nil? or files.empty?
        Dir[glob].flatten
      else
        Dir[glob].flatten & files
      end
    end

    #
    def counts
      @counts ||= (
        table = Hash.new{ |h,k| h[k] = 0 }
        config.matchers.each do |glob, block|
          files = resolve_files(glob)
          files.each do |file|
            File.readlines(file).each do |line|
              line = line.chomp("\n")
              group = block.call(file, line)
              if group
                table[group.to_s] += 1
              end
            end
          end
        end
        table
      )
    end

    #
    def total
      @total = counts.values.inject(0){ |s,v| s+=v; s }
    end

    #
    def loc
      @loc ||= (
        a = []
        a << [nil  , *counts.keys]
        a << ['loc', *counts.values]
        a
      )
    end

    # Compute the ratios between each group,
    # returning a two-dimensional array.
    def ratio
      @ratio ||= (
        rcounts = counts.dup
        rcounts['Total'] = total
        r = Array.new(rcounts.size+1){ [] }
        x = 1
        rcounts.each do |type1, count1|
          r[x][0] = type1
          y = 1
          rcounts.each do |type2, count2|
            r[0][y] = type2
            r[x][y] = (1000 * (count2.to_f / count1.to_f)).round.to_f / 1000.0
            y += 1
          end
          x += 1
        end
        r
      )
    end

    # Calculate the percentages.
    def percent
      @percent ||= (
        a = []
        a << [nil  ,  *counts.keys]
        a << ['%', *counts.values.map{ |f| 100 * f / total }]
        a
      )
    end

    #
    def to_json
      { :loc   => loc,
        :pcnt  => percent,
        :ratio => ratio
      }.to_json
    end

    #
    def __binding__
      binding
    end

  end

  #
  #
  class Config

    #
    def initialize(*config_files)
      @matchers = []

      config_files.each do |f|
        instance_eval(File.read(f))
      end
    end

    attr :matchers

    def match(files, &block)
      @matchers << [files, block]
    end

    #
    def title
       metadata['title']
    end

    private

    #
    def metadata
      @metadata ||= (
        if File.file?('.ruby')
          YAML.load(File.new('.ruby'))
        else
          {}
        end
      )
    end
  end

end
