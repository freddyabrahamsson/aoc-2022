# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

lib_root = File.dirname(__FILE__)
Dir.glob("#{lib_root}/days/*") { |f| require f }

###
# Collection of all the implemented days.
module Days
  extend T::Sig

  IMPLEMENTED_DAYS = T.let({}.freeze, T::Hash[Integer, T.class_of(Day)])
end
