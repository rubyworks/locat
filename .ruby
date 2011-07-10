--- 
name: locat
version: 0.1.1
title: LOCat
summary: Lines of Code Attache
description: LOCat is a customizable Lines-Of-Code analysis tool. LOC might not be the most useful metric in the universe, but it still provides useful information and can be a lot of fun.
loadpath: 
- lib
manifest: MANIFEST
requires: 
- name: grit
  version: 0+
  group: []

- name: ansi
  version: 0+
  group: []

- name: detroit
  version: 0+
  group: 
  - build
- name: qed
  version: 0+
  group: 
  - test
conflicts: []

replaces: []

engine_check: []

organization: Rubyworks
contact: trans <transfire@gmail.com>
created: 2011-07-07
copyright: Copyright (c) 2011 Thomas Sawyer
licenses: 
- BSD-2-Clause
authors: 
- Thomas Sawyer
maintainers: []

resources: 
  home: http://rubyworks.github.com/locat
  code: http://github.com/rubyworks/locat
  docs: http://rubydoc.info/gems/locat/frames
  bugs: http://github.com/rubyworks/locat/issues
  mail: http://groups.google.com/group/rubyworks-mailinglist
repositories: 
  public: git://github.com/rubyworks/locat.git
spec_version: 1.0.0
