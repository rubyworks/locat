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
    FILE_EXTENSION = /\.{rb,js}$/
    EXCLUDED_FILES = %w(files.js to.js exclude.js).map { |str| Regexp.escape(str) }.join('|')
    EXCLUDED       = /#{EXCLUDED_FILES}/i
    PER_DAY        = true # true = show 1-commit-per-day, false = show all commits

    attr :repo

    #
    def initialize
      @repo = Repo.new(".")

      @output_file      = OUTPUT_FILE
      @file_extension   = FILE_EXTENSION
      @exclude          = EXCLUDE
      @per_day          = PER_DAY
    end

    #
    def title
      "'#{repo.head.name}' branch JavaScript LOC #{@per_day ? 'per day' : 'per commit'}"
    end

    #
    def recursive_loc_count(tree_or_blob)
      if tree_or_blob.is_a?(Grit::Tree)
        # A directory
        tree_or_blob.contents.each do |tob|
          recursive_loc_count(tob)
        end
      elsif tree_or_blob.is_a?(Grit::Blob) \
            && tree_or_blob.name =~ @file_extension \
            && tree_or_blob.name !~ @exclude
        # A matched file
        total_count += tree_or_blob.data.select { |line| line !~ /^[\n\s\r]*$/ }.count
      else
        # A non-matched file.
      end
    end

    #
    def generate
      commits_with_loc = []
      total_count      = 0 # gets reset every commit
      current_date     = nil # gets reset every commit

      # puts repo.commits[0].methods.sort.join(', ')
      repo.commits('master', MAX_COMMITS).each do |commit|
        total_count = 0
        this_date = commit.committed_date.to_date
        
        if !@per_day || (@per_day && this_date != current_date)
          # Record this commit as end-of-day commit
          current_date = this_date
          commit.tree.contents.each(&recursive_loc_count)
          commits_with_loc << {
            :date => commit.committed_date.to_datetime.strftime("%-m/%-d/%y"),
            :id   => commit.id,
            :loc  => total_count
          }
        else
          # The day this commits falls on has already been recorded
        end
      end

      mod = (commits_with_loc.size / 5).round
      commits_with_loc.reverse!

      template_file = File.dirname(__FILE__) + '/template/gitloc.rhtml'
      template = ERB.new(File.read(template_file))
      html = template.result(binding)
    end

    #FileUtils.rm_f(OUTPUT_FILE)
    #f = File.open(OUTPUT_FILE, 'w').write(html)
  end

end
