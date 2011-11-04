module LOCat

  #
  def self.cli(*argv)
    options = {}

    OptionParser.new do |opt|
      opt.on('-o', '--output FILE', 'output file') do |output|
        options[:output] = output
      end
      opt.on('-j', '--json', 'output JSON formmated data') do
        options[:format] = 'json'
      end
      opt.on('-y', '--yaml', 'output YAML formmated data') do
        options[:format] = 'yaml'
      end
      opt.on('-c', '--config NAME', 'matcher configuraton') do |name|
        options[:config] ||= []
        options[:config] << name
      end
      opt.on('-t', '--title TITLE', 'title to put on report') do |title|
        options[:title] = title
      end
      opt.on('-D', '--debug', 'run in debug mode') do
        $DEBUG = true
      end
      opt.on('-h', '--help', 'display this help message') do
        puts opt
        exit 0
      end
    end.parse!(argv)

    options[:files] = argv

    command = Command.new(options)
    command.run
  end

  #
  class Command

    #
    def initialize(options)
      @files        = nil
      @output       = nil
      @format       = 'highchart'
      @config       = default_config_files
      @title        = nil

      options.each do |k,v|
        send("#{k}=", v)
      end
    end

    # Files to include in analysis.
    attr_accessor :files

    # The output format (json, yaml, highchart).
    attr_accessor :format

    # List of configuration files.
    attr_accessor :config

    # List of configuration files.
    attr_accessor :title

    # Output file.
    attr_reader :output

    # Set output file name.
    def output=(file)
      @output = file
    end

    #
    def run
      save
    end

   private

    #
    def default_config_files
      Dir['.locat{,/*.rb}'].select{ |f| File.file?(f) }
    end

    #
    def matcher
      @matcher ||= Matcher.new(*([config].flatten))
    end

    #
    def counter
      @counter ||= Counter.new(matcher, :files=>files)
    end

    # Access to .ruby metadata. This only really cares about
    # the `title` field (at this point). If no `.ruby` file
    # is found, the title is set to the basename of the current
    # working directory.
    def metadata
      @metadata ||= (
        if File.file?('.ruby')
          data = YAML.load(File.new('.ruby'))
        else
          data = {}
        end
        data['title'] = title if title
        data
      )
    end

    #
    def template
      @template ||= Template.new(counter, metadata)
    end

    # Save.
    def save
      case format.downcase
      when 'json'
        json = counter.to_h.to_json
        save_file(json)
      when 'yaml'
        yaml = counter.to_h.to_yaml
        save_file(yaml)
      else
        html = template.render(format)
        save_file(html)
      end
    end

    #
    def save_file(text)
      if output
        FileUtils.mkdir_p(File.dirname(output))
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

end
