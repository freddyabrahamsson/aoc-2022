# frozen_string_literal: true

require "rake"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"

task default: :spec

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:days_spec) do |t|
  t.pattern = Dir.glob("spec/days/*.rb")
end

RSpec::Core::RakeTask.new(:controller_spec) do |t|
  t.pattern = Dir.glob("spec/utils/controller/*.rb")
end

RSpec::Core::RakeTask.new(:utils_spec) do |t|
  t.pattern = Dir.glob("spec/utils/*.rb")
end

RuboCop::RakeTask.new(:lint)

YARD::Rake::YardocTask.new do |t|
  t.stats_options = ["--list-undoc"]
end

task app_spec: %i[controller_spec utils_spec]
