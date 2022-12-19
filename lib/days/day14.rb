# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  class StopFallingError < StandardError
  end

  class Coordinate < T::Struct
    prop :x, Integer
    prop :y, Integer
  end

  ##
  # A grain of sand
  class Grain
    extend T::Sig

    sig { params(grid: Grid).void }
    def initialize(grid)
      @grid = grid
      @pos = T.let(Coordinate.new(x: 500, y: 0), Coordinate)
      @resting = T.let(false, T::Boolean)
    end

    sig { void }
    def move_to_next_or_rest
      current_x = @pos.x
      next_y = @pos.y + 1
      if @grid.space_free?(current_x, next_y)
        move_down
      elsif @grid.space_free?(current_x - 1, next_y)
        move_down_left
      elsif @grid.space_free?(current_x + 1, next_y)
        move_down_right
      else
        come_to_rest
      end
    end

    sig { void }
    def fall_a
      until @resting
        move_to_next_or_rest
        raise StopFallingError if @pos.y > @grid.max_y
      end
    end

    sig { void }
    def fall_b
      until @resting
        move_to_next_or_rest
        raise StopFallingError if @pos.y.zero?
      end
    end

    sig { void }
    def move_down
      @pos.y += 1
    end

    sig { void }
    def move_down_left
      @pos.y += 1
      @pos.x -= 1
    end

    sig { void }
    def move_down_right
      @pos.y += 1
      @pos.x += 1
    end

    sig { void }
    def come_to_rest
      @grid.occupy(@pos)
      @resting = true
    end
  end

  ##
  # A grid
  class Grid
    extend T::Sig

    sig { returns(Integer) }
    attr_reader :max_y

    sig { void }
    def initialize
      @points = T.let({}, T::Hash[Integer, T::Hash[Integer, T::Boolean]])
      @max_y = T.let(0, Integer)
    end

    sig { params(x_c: Integer, y_c: Integer).returns(T::Boolean) }
    def space_free?(x_c, y_c)
      return false if y_c == floor
      return true if @points[y_c].nil?
      return true if T.must(@points[y_c])[x_c].nil?

      T.must(T.must(@points[y_c])[x_c])
    end

    sig { params(coord: Coordinate).void }
    def occupy(coord)
      @points[coord.y] = Hash.new(true) if @points[coord.y].nil?
      T.must(@points[coord.y])[coord.x] = false
    end

    sig { params(wall_str: String).void }
    def add_wall_from_string(wall_str)
      corners = wall_str.split(" -> ").map do |corner_str|
        corner_nums = corner_str.split(",").map(&:to_i)
        Coordinate.new(x: T.must(corner_nums[0]), y: T.must(corner_nums[1]))
      end
      corners.each_cons(2) do |corner_pair|
        add_wall_between(T.must(corner_pair[0]), T.must(corner_pair[1]))
      end
    end

    private

    sig { returns(Integer) }
    def floor
      @max_y + 2
    end

    sig { params(coord_a: Coordinate, coord_b: Coordinate).void }
    def add_wall_between(coord_a, coord_b)
      wall_range(coord_a.x, coord_b.x).each do |x|
        wall_range(coord_a.y, coord_b.y).each do |y|
          @points[y] = Hash.new(true) if @points[y].nil?
          T.must(@points[y])[x] = false
          update_max_y(y)
        end
      end
    end

    sig { params(y_val: Integer).void }
    def update_max_y(y_val)
      @max_y = y_val if y_val > @max_y
    end

    sig { params(coord_a: Integer, coord_b: Integer).returns(T::Range[Integer]) }
    def wall_range(coord_a, coord_b)
      min_c = [coord_a, coord_b].min
      max_c = [coord_a, coord_b].max
      (min_c..max_c)
    end
  end

  ##
  # Day 14
  class Day14 < Day
    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 14.
    #
    # @return the answer to part a, day 14.
    def part_a
      g = Grid.new
      @input_lines.each do |line|
        g.add_wall_from_string(line)
      end
      count = 0
      loop do
        grain = Grain.new(g)
        grain.fall_a
        count += 1
      rescue StopFallingError
        break
      end
      count
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 14.
    #
    # @return the answer to part B, day 14.
    def part_b
      g = Grid.new
      @input_lines.each do |line|
        g.add_wall_from_string(line)
      end
      count = 0
      loop do
        grain = Grain.new(g)
        count += 1
        grain.fall_b
      rescue StopFallingError
        break
      end
      count
    end
  end
end
