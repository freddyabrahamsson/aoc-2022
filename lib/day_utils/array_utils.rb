# typed: strict
# frozen_string_literal:true

##
# Utilities for arrays
class Array
  extend T::Sig

  sig { params(split_elem: T.untyped).returns(T::Array[T.untyped]) }
  def split_on(split_elem)
    output = []
    sub_arr = []
    each do |elem|
      if elem.eql?(split_elem)
        output << sub_arr unless sub_arr.empty?
        sub_arr = []
      else
        sub_arr << elem
      end
    end
    output << sub_arr unless sub_arr.empty?
    output
  end
end
