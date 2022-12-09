# typed: strict
# frozen_string_literal: true

require "rake"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

require_relative("lib/aoc_rake_tasks")

Rake::TestTask.new(:bench) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/bench_*.rb"]
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

Rake::TestTask.new(:test_days) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/days/test_*.rb"]
end

Rake::TestTask.new(:test_app) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/utils/test_*.rb",
                          "test/test_controller.rb"]
end

RuboCop::RakeTask.new(:lint) do |t|
  t.formatters = ["simple"]
end

RuboCop::RakeTask.new(:lint_autocorrect) do |t|
  t.formatters = ["simple"]
  t.options = %w[--autocorrect --disable-uncorrectable]
end

YARD::Rake::YardocTask.new(:gen_docs) do |_t|
  YARD::Config.load_plugin("sorbet")
end

YARD::Rake::YardocTask.new(:undoc) do |t|
  t.stats_options = ["--list-undoc"]
end
