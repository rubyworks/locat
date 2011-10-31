---
source:
- meta
authors:
- name: Trans
  email: transfire@gmail.com
copyrights:
- holder: Rubyworks
  year: '2011'
  license: BSD-2-Clause
replacements: []
alternatives: []
requirements:
- name: grit
- name: ansi
- name: json
- name: detroit
  groups:
  - build
  development: true
- name: qed
  groups:
  - test
  development: true
dependencies: []
conflicts: []
repositories:
- uri: git://github.com/rubyworks/locat.git
  scm: git
  name: upstream
resources:
  home: http://rubyworks.github.com/locat
  code: http://github.com/rubyworks/locat
  docs: http://rubydoc.info/gems/locat/frames
  bugs: http://github.com/rubyworks/locat/issues
  mail: http://groups.google.com/group/rubyworks-mailinglist
extra: {}
load_path:
- lib
revision: 0
created: '2011-07-07'
summary: Lines of Code Attache
title: LOCat
version: 0.1.2
name: locat
description: LOCat is a customizable Lines-Of-Code analysis tool. LOC might not be
  the most useful metric in the universe, but it still provides useful information
  and can be a lot of fun.
organization: Rubyworks
date: '2011-10-30'
