# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 23
  class Day23 < Day
    Coord = T.type_alias { [Integer, Integer] }

    class Direction < T::Enum
      extend T::Sig
      enums do
        N = new
        E = new
        S = new
        W = new
      end

      sig { returns(Direction) }
      def nxt
        case self
        when N then S
        when S then W
        when W then E
        when E then N
        end
      end
    end

    sig { params(lines: T::Array[String]).returns(T::Set[Coord]) }
    def parse_elves(lines)
      Set.new(lines.map.with_index do |line, y|
        line.chars.map.with_index { |c, x| [x, y] if c.eql?("#") }.compact
      end.flatten(1))
    end

    sig { params(coord: Coord, dir: Direction).returns(T::Array[Coord]) }
    def neigbour_coords(coord, dir)
      x = coord.first
      y = coord.last
      case dir
      when Direction::N then [x - 1, x, x + 1].product([y - 1])
      when Direction::E then [x + 1].product([y - 1, y, y + 1])
      when Direction::S then [x - 1, x, x + 1].product([y + 1])
      when Direction::W then [x - 1].product([y - 1, y, y + 1])
      end
    end
    sig { params(coord: Coord).returns(T::Array[Coord]) }
    def all_neighbours(coord)
      x = coord.first
      y = coord.last
      (x - 1..x + 1).to_a.product((y - 1..y + 1).to_a).reject { |c| c == coord }
    end

    sig { params(coord: Coord, dir: Direction).returns(Coord) }
    def target(coord, dir)
      x = coord.first
      y = coord.last
      case dir
      when Direction::N then [x, y - 1]
      when Direction::E then [x + 1, y]
      when Direction::S then [x, y + 1]
      when Direction::W then [x - 1, y]
      end
    end

    sig { params(elves: T::Set[Coord], first_dir: Direction).returns(T::Set[Coord]) }
    def round(elves, first_dir)
      next_coords = {}
      next_coord_counter = Hash.new(0)
      elves.each do |elf|
        next if all_neighbours(elf).none? { |n| elves.include?(n) }

        d = first_dir
        4.times do
          targets = neigbour_coords(elf, d)
          unless targets.any? { |n| elves.include?(n) }
            t = target(elf, d)
            next_coords[elf] = t
            next_coord_counter[t] += 1
            break
          end
          d = d.nxt
        end
      end
      elves.each do |elf|
        unless next_coords.key?(elf)
          next_coords[elf] = elf
          next_coord_counter[elf] += 1
        end
      end
      next_set = T.let(Set.[], T::Set[Coord])
      elves.each do |elf|
        t = next_coords.fetch(elf)
        if next_coord_counter[t] < 2
          next_set.add(t)
        else
          next_set.add(elf)
        end
      end
      next_set
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 23.
    #
    # @return the answer to part a, day 23.
    def part_a
      elves = parse_elves(@input_lines)
      d = T.let(Direction::N, Direction)
      10.times do
        elves = round(elves, d)
        d = d.nxt
      end
      xs = elves.minmax_by(&:first).map(&:first)
      ys = elves.minmax_by(&:last).map(&:last)
      (T.must(xs.last) - T.must(xs.first) + 1) * (T.must(ys.last) - T.must(ys.first) + 1) - elves.size
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 23.
    #
    # @return the answer to part B, day 23.
    def part_b
      elves = parse_elves(@input_lines)
      d = T.let(Direction::N, Direction)
      next_elves = T.let(Set.[], T::Set[[Integer, Integer]])
      counter = 0
      loop do
        next_elves = round(elves, d)
        counter += 1
        break if next_elves.eql?(elves)

        elves = next_elves
        d = d.nxt
      end
      counter
    end
  end
end
