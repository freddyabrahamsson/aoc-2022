# typed: true
# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "minitest/benchmark"
require "minitest/reporters"
require "rake"
require "rake/testtask"
require "rubocop/rake_task"
require "set"
require "sorbet-runtime"
require "tty-logger"
require "tty-prompt"
require "yard"
