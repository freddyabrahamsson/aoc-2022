# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:days_spec) do |t|
  t.pattern = Dir.glob('spec/days/*.rb')
  t.rspec_opts = '--format documentation'
end

RSpec::Core::RakeTask.new(:utils_spec) do |t|
  t.pattern = Dir.glob('spec/utils/*.rb')
end

task default: :spec
