module LOCat

  #
  class Counter

    #
    def initialize(matcher, options)
      @matcher = matcher

      options.each do |k,v|
        send("#{k}=", v)
      end
    end

    #
    attr :matcher

    #
    attr :files

    #
    def files=(files)
      @files = files.map{ |f| Dir[f] }.flatten
    end

    #
    def counts
      @counts ||= (
        table = Hash.new{ |h,k| h[k] = 0 }
        matcher.each do |pattern, block|
          files = resolve_files(pattern)
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
            if count2 == 0 or count2 == 0
              r[x][y] = 0
            else
              r[x][y] = (1000 * (count2.to_f / count1.to_f)).round.to_f / 1000.0
            end
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
    def to_h
      h = {}
      h['loc']   = loc
      h['pcnt']  = percent
      h['ratio'] = ratio
      h['scm']   = scm if scm?
      h
    end

    #
    #def to_json
    #  to_h.to_json
    #end

    #
    def gitloc
      @gitloc ||= GitLOC.new(matcher)
    end

    #
    def scm?
      File.directory?('.git')
    end

    #
    def scm
      if scm?
        gitloc.timeline_table
      else
        nil
      end
    end

    private

    # Resolve file glob.
    def resolve_files(pattern)
      case pattern
      when String
        Dir['**/*'].select{ |path| File.fnmatch(pattern, path) }
      when Regexp
        Dir['**/*'].select{ |path| pattern =~ path }
      else
        []
      end
      #if File.directory?(glob)
      #  glob = File.join(glob, '**', '*')
      #end
      #if files.nil? or files.empty?
      #  Dir[glob].flatten
      #else
      #  Dir[glob].flatten & files
      #end
    end

  end

end
