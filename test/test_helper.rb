# typed: true
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "minitest/autorun"
require "sorbet-runtime"

require_relative "../lib/utils/filename_utils"
