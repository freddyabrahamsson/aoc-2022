# typed: strict
# frozen_string_literal:true

require "sorbet-runtime"

##
# Utilities for arrays
class Array
  extend T::Sig
  extend T::Generic

  T::Sig::WithoutRuntime.sig do
    type_parameters(:U)
      .params(split_elem: T.type_parameter(:U))
      .returns(T::Array[T::Array[Elem]])
  end
  def split_on(split_elem)
    output = []
    group = []
    each do |elem|
      if elem.eql?(split_elem)
        output << group unless group.empty?
        group = []
      else
        group << elem
      end
    end
    output << group unless group.empty?
    output
  end
end
