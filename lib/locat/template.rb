module LOCat

  #
  class Template

    #
    DIRECTORY = File.dirname(__FILE__) + '/template'

    #
    def initialize(counter)
      @counter = counter
    end

    #
    attr :counter

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
      "The LOCat on " + metadata['title']
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

    # Access to .ruby metadata.
    def metadata
      @metadata ||= (
        if File.file?('.ruby')
          YAML.load(File.new('.ruby'))
        else
          {}
        end
      )
    end

    #
    def __binding__
      binding
    end

  end

end
