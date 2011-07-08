require 'rubygems'
#require 'active_support'
require 'grit'
require 'open-uri'
require 'fileutils'

module LOCat

  # Based on `git-line-count.rb` by Tieg Zaharia
  class GitLOC

    include Grit

    MAX_COMMITS    = 1_000_000
    OUTPUT_FILE    = "gitloc.html"
    #FILE_EXTENSION = /\.(rb|js)$/
    #EXCLUDED_FILES = %w(files.js to.js exclude.js).map{ |str| Regexp.escape(str) }.join('|')
    #EXCLUDED       = /#{EXCLUDED_FILES}/i
    PER_DAY        = false # true = show 1-commit-per-day, false = show all commits
    DATA_POINTS    = 25

    attr :matcher

    attr :repo

    #
    def initialize(matcher)
      @matcher = matcher
      @repo    = Repo.new(".")

      @data_points      = DATA_POINTS
      @output_file      = OUTPUT_FILE
      #@file_extension   = FILE_EXTENSION
      #@exclude          = EXCLUDED
      @per_day          = PER_DAY
    end

    #
    def title
      "'#{repo.head.name}' branch JavaScript LOC #{@per_day ? 'per day' : 'per commit'}"
    end

    # Count lines by groups.
    def recursive_loc_count(dir, tree_or_blob, total_count=nil)
      total_count ||= Hash.new{|h,k| h[k]=0 }
      if tree_or_blob.is_a?(Grit::Tree) # directory
        tree_or_blob.contents.each do |tob|
          dname = dir ? File.join(dir, tree_or_blob.name) : tree_or_blob.name
          recursive_loc_count(dname, tob, total_count)
        end
      elsif tree_or_blob.is_a?(Grit::Blob) # file
        file = dir ? File.join(dir, tree_or_blob.name) : tree_or_blob.name
        matcher.each do |glob, block|
          if File.fnmatch?(glob, file)
            tree_or_blob.data.lines.each do |line|
              group = block.call(file, line)
              if group
                total_count[group] += 1
              end
              #total_count['Total'] += 1
            end
          end
        end
      else
        # what is it then?
      end
      total_count
    end

    #
    def commits_with_loc
      @commits_with_loc ||= (
        table        = []
        total_count  = Hash.new{|h,k|h[k]=0}   # gets reset every commit
        current_date = nil                     # gets reset every commit

        size = repo.commits('master', MAX_COMMITS).size
        mod  = size < @data_points ? 1 : (size / @data_points).round

        # puts repo.commits[0].methods.sort.join(', ')
        repo.commits('master', MAX_COMMITS).each_with_index do |commit, index|
          next unless index % mod == 0

          total_count = Hash.new{|h,k|h[k]=0}
          this_date   = commit.committed_date.to_date
          if !@per_day || (@per_day && this_date != current_date)
            # Record this commit as end-of-day commit
            current_date = this_date
            commit.tree.contents.each do |tob|
              recursive_loc_count(nil, tob, total_count)
            end
            table << {
              :date => commit.committed_date.to_datetime,
              :id   => commit.id,
              :loc  => total_count
            }
          else
            # The day this commits falls on has already been recorded
          end
        end

        table.reverse
      )
    end

    #
    def timeline_table
      #mod = 7
      th = [nil]
      commits_with_loc.each_with_index do |commit, index|
        #if index % mod == 0 || index == commits_with_loc.size - 1
        #  th << commit[:date].strftime("%-y %-m %-d")
        #else
          th << commit[:date].strftime("%y %m %d")
        #end
      end
      tg = []
      groups = []
      commits_with_loc.each do |commit|
        groups = groups | commit[:loc].keys
      end
      groups.each_with_index do |g, i|
        tg[i] = [g]
      end
      tt = ['Total']
      commits_with_loc.each do |commit|
        sum = 0
        groups.each_with_index do |g, i|
          tg[i] << commit[:loc][g]
          sum += commit[:loc][g]
        end
        tt << sum
      end
      [th] + tg + [tt]
    end

  end

end
