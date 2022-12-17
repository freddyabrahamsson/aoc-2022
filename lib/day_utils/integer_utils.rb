# typed: strict
# frozen_string_literal: true

##
# Extended integer class
class Integer
  extend T::Sig
  extend T::Generic

  ##
  # Check if this number divides the other number.
  #
  # @param other an Integer to check against
  # @return true if this number divides other
  sig { params(other: Integer).returns(T::Boolean) }
  def divides?(other)
    (other % self).zero?
  end
end
