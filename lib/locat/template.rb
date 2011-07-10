module LOCat

  #
  class Template

    #
    DIRECTORY = File.dirname(__FILE__) + '/template'

    #
    def initialize(counter, metadata)
      @counter  = counter
      @metadata = metadata
    end

    #
    attr :counter

    #
    attr :metadata

    #
    def total
      counter.total
    end

    #
    def counts
      counter.counts
    end

    #
    def table_loc
      counter.loc
    end

    #
    def table_pcnt
      counter.percent
    end

    #
    alias_method :table_percentages, :table_pcnt

    #
    def table_ratio
      counter.ratio
    end

    #
    def table_scm
      counter.scm
    end

    #
    def to_json
      h = {}
      h[:loc]   = table_loc
      h[:pcnt]  = table_pcnt
      h[:ratio] = table_ratio
      h[:scm]   = table_scm if scm?
      h.to_json
    end

    #
    def scm?
      File.directory?('.git')
    end
 
    #
    def title
      "The LOCat on " + (metadata['title'] || File.basename(Dir.pwd))
    end

    #
    def javascript
      @javascript ||= (
        File.read(File.join(DIRECTORY, 'javascript.js'))
      )
    end

    #
    def render(template)
      file = File.join(DIRECTORY, template + '.rhtml')
      erb  = ERB.new(File.read(file))
      erb.result(__binding__)
    end

    private

    #
    def __binding__
      binding
    end

  end

end
