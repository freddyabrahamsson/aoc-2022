# typed: strict
# frozen_string_literal: true

require "rake"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

task default: :spec

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

RuboCop::RakeTask.new(:lint)

RuboCop::RakeTask.new(:lint_autocorrect) do |t|
  t.formatters = ["simple"]
  t.options = %w[--autocorrect --disable-uncorrectable]
end

YARD::Rake::YardocTask.new(:undoc) do |t|
  t.stats_options = ["--list-undoc"]
end

task app_spec: %i[controller_spec utils_spec]
