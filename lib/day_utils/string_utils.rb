# typed: strict
# frozen_string_literal: true

class String
  extend T::Sig

  sig { returns(T::Array[Float]) }
  # Grabs all numbers in a string which are not part of a word.
  #
  # ```
  #    "1".grab_numbers                           #=> [1.0]
  #    "1 is a number".grab_numbers               #=> [1.0]
  #    "-2.1 is a float".grab_numbers             #=> [-2.1]
  #    "part1 is name, 22 is number".grab_numbers #=> [22.0]
  #    "1 and 2 and 3".grab_numbers               #=> [1.0, 2.0, 3.0]
  # ```
  #
  # @return an array of numbers from the string
  def grab_numbers
    # Casting is safe because the regex contains no captured groups.
    T.cast(scan(/(?<!\S)-?[\d+|.]+(?!\S)/), T::Array[String]).map(&:to_f)
  end
end
