module LOCat

  #
  class Matcher
    include Enumerable

    #
    def initialize(*config_files)
      @rules = []

      if config_files.empty?
        default
      end

      config_files.each do |f|
        instance_eval(File.read(f))
      end
    end

    #
    attr :rules

    #
    def match(files, &block)
      @rules << [files, block]
    end

    #
    def each(&block)
      @rules.each(&block)
    end

    #
    def size
      @rules.size
    end

  private

    # Default configuration if none is supplied by the project.
    def default
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
    end

  end

end
