# RELEASE HISTORY

## 0.2.2 | 2014-01-13

This is a minor release that deals with a couple of minor issues,
albeit the issue with a broken grit dependency can cause locat to crash.

Changes:

* If Grit fails then gracely skip git timeline analysis.
* Don't try to create logging directory if it already exists.


## 0.2.0 | 2011-11-04

This release upgrades the HighCharts javascript dependency a notch
to v2.1.6, and provides a default configuration when none is provided
by a project --which makes it even easier to get started using LOCat!

Changes:

* Use default configuration if none supplied by project.
* Update HighCharts dependency to 2.1.6.


## 0.1.2 | 2011-07-11

Doh. Can I not write one line of code with a bug creeping
into it! Any how, this release just fixes a typo in the CLI
parsing code, and adds a default encoding for Ruby 1.9.

Changes:

* Fix missing bracket in cli options parsing.
* Set default encoding.


## 0.1.1 | 2011-07-10

This release fixes a few issues reported by friendly cats.
It also adds a new command line option to set the document
title.

Changes:

* Title can now be set via cli.
* Fix Time#to_date missing method. #3
* Fix metadata['title'] nil value. #3
* Add grit dependency. #2


## 0.1.0 | 2011-07-08 | The Cat's Meow

This is the first release of LOCat a 
fancy LOC analysis tool.

Changes:

* Its all "change" at this point!

