--- !ruby/object:Gem::Specification 
name: locat
version: !ruby/object:Gem::Version 
  prerelease: 
  version: 0.1.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2011-07-07 00:00:00 Z
dependencies: 
- !ruby/object:Gem::Dependency 
  name: ansi
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :runtime
  version_requirements: *id001
- !ruby/object:Gem::Dependency 
  name: detroit
  prerelease: false
  requirement: &id002 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :development
  version_requirements: *id002
- !ruby/object:Gem::Dependency 
  name: qed
  prerelease: false
  requirement: &id003 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :development
  version_requirements: *id003
description: LOCat is a customizable Line-Of-Code metric system. LOC might not be the most useful metric in the universe but it still provide useful inforamtion and can be a lot of fun.
email: transfire@gmail.com
executables: 
- locat
extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .ruby
- bin/locat
- lib/locat/git-line-count.rb
- lib/locat/template/index.html
- lib/locat.rb
- README.rdoc
homepage: http://rubyworks.github.com/locat
licenses: 
- BSD-2-Clause
post_install_message: 
rdoc_options: 
- --title
- LOCat API
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
requirements: []

rubyforge_project: locat
rubygems_version: 1.8.2
signing_key: 
specification_version: 3
summary: Lines of Code Attache
test_files: []

