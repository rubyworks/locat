module LOCat

  #
  class Matcher
    include Enumerable

    #
    def initialize(*config_files)
      @rules = []

      if config_files.empty?
        raise ArgumentError, 'no configuration files'
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
  end

end
