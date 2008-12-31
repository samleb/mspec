#!/usr/bin/env ruby

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'mspec/version'
require 'mspec/utils/options'
require 'mspec/utils/script'


class MSpecRun < MSpecScript
  def initialize
    super

    config[:files] = []
  end

  def options(argv=ARGV)
    options = MSpecOptions.new "mspec run [options] (FILE|DIRECTORY|GLOB)+", 30, config

    options.doc " Ask yourself:"
    options.doc "  1. What specs to run?"
    options.doc "  2. How to modify the execution?"
    options.doc "  3. How to display the output?"
    options.doc "  4. What action to perform?"
    options.doc "  5. When to perform it?"

    options.doc "\n What specs to run"
    options.filters

    options.doc "\n How to modify the execution"
    options.prefix
    options.configure { |f| load f }
    options.name
    options.randomize
    options.pretend
    options.unguarded
    options.interrupt

    options.doc "\n How to display their output"
    options.formatters
    options.verbose

    options.doc "\n What action to perform"
    options.actions
    options.verify

    options.doc "\n When to perform it"
    options.action_filters

    options.doc "\n Help!"
    options.version MSpec::VERSION
    options.help

    options.doc "\n How might this work in the real world?"
    options.doc "\n   1. To simply run some specs"
    options.doc "\n     $ mspec path/to/the/specs"
    options.doc "     mspec path/to/the_file_spec.rb"
    options.doc "\n   2. To run specs tagged with 'fails'"
    options.doc "\n     $ mspec -g fails path/to/the_file_spec.rb"
    options.doc "\n   3. To start the debugger before the spec matching 'this crashes'"
    options.doc "\n     $ mspec --spec-debug -S 'this crashes' path/to/the_file_spec.rb"
    options.doc ""

    patterns = options.parse argv
    patterns = config[:files] if patterns.empty?
    if patterns.empty?
      puts options
      puts "No files specified."
      exit 1
    end
    @files = files patterns
  end

  def run
    MSpec.register_tags_patterns config[:tags_patterns]
    MSpec.register_files @files

    MSpec.process
    exit MSpec.exit_code
  end
end

