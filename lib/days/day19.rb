# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 19
  class Day19 < Day
    class Blueprint < T::Struct
      extend T::Sig
      const :id, Integer
      const :oroc, Integer
      const :croc, Integer
      const :obsroc, Integer
      const :obsrcc, Integer
      const :groc, Integer
      const :grobsc, Integer

      sig { returns(Integer) }
      def max_o_spend
        [oroc, croc, obsroc, groc].max
      end

      sig { params(bp_str: String).returns(Blueprint) }
      def self.from_string(bp_str)
        bp_pattern = /Blueprint (?<id>\d+): Each ore robot costs (?<oroc>\d+) ore. Each clay robot costs (?<croc>\d+) ore. Each obsidian robot costs (?<obsroc>\d+) ore and (?<obsrcc>\d+) clay. Each geode robot costs (?<groc>\d+) ore and (?<grobsc>\d+) obsidian./
        raise ArgumentError, "Could not match blueprint for '#{bp_str}'" unless matches = bp_str.match(bp_pattern)

        ms = matches.named_captures.transform_values(&:to_i)
        Blueprint.new(id: ms.fetch("id"),
                      oroc: ms.fetch("oroc"),
                      croc: ms.fetch("croc"),
                      obsroc: ms.fetch("obsroc"),
                      obsrcc: ms.fetch("obsrcc"),
                      groc: ms.fetch("groc"),
                      grobsc: ms.fetch("grobsc"))
      end
    end

    ##
    # Status for search
    #
    # @param bp TODO
    # @param t_limit TODO
    # @param status TODO
    # @param cache TODO
    # @param max_cache TODO
    # @return TODO
    class SearchStatus < T::Struct
      extend T::Sig
      prop :time, Integer, default: 0

      prop :o_robots, Integer, default: 1
      prop :c_robots, Integer, default: 0
      prop :obs_robots, Integer, default: 0
      prop :g_robots, Integer, default: 0

      prop :ore, Integer, default: 0
      prop :clay, Integer, default: 0
      prop :obs, Integer, default: 0
      prop :geodes, Integer, default: 0

      sig { params(bp: Blueprint).returns(T::Array[SearchStatus]) }
      def next_statuses(bp)
        nss = []
        nss << g_robot_next(bp) if obs_robots.positive?
        nss << obs_robot_next(bp) if (obs_robots < bp.grobsc) && c_robots.positive?
        nss << c_robot_next(bp) if c_robots < bp.obsrcc
        nss << o_robot_next(bp) if o_robots < bp.max_o_spend

        nss
      end

      sig { params(time_limit: Integer).returns(Integer) }
      def pot(time_limit)
        geodes + g_robots * (time_limit - time) + (1...(time_limit - time)).sum
      end

      sig { params(bp: Blueprint, time_limit: Integer).void }
      def normalise!(bp, time_limit)
        time_left = time_limit - time
        self.ore = [ore, time_left * bp.max_o_spend].min
        self.clay = [clay, time_left * bp.obsrcc].min
        self.obs = [obs, time_left * bp.grobsc].min
      end

      private

      sig { params(bp: Blueprint).returns(SearchStatus) }
      def o_robot_next(bp)
        time_needed = [0, ((bp.oroc - ore) / o_robots.to_f).ceil].max + 1
        with(time: time + time_needed,
             o_robots: o_robots + 1,
             ore: ore + time_needed * o_robots - bp.oroc,
             clay: clay + time_needed * c_robots,
             obs: obs + time_needed * obs_robots,
             geodes: geodes + time_needed * g_robots)
      end

      sig { params(bp: Blueprint).returns(SearchStatus) }
      def c_robot_next(bp)
        time_needed = [0, ((bp.croc - ore) / o_robots.to_f).ceil].max + 1
        with(time: time + time_needed,
             c_robots: c_robots + 1,
             ore: ore + time_needed * o_robots - bp.croc,
             clay: clay + time_needed * c_robots,
             obs: obs + time_needed * obs_robots,
             geodes: geodes + time_needed * g_robots)
      end

      sig { params(bp: Blueprint).returns(SearchStatus) }
      def obs_robot_next(bp)
        time_needed = [0, ((bp.obsroc - ore) / o_robots.to_f).ceil, ((bp.obsrcc - clay) / c_robots.to_f).ceil].max + 1
        with(time: time + time_needed,
             obs_robots: obs_robots + 1,
             ore: ore + time_needed * o_robots - bp.obsroc,
             clay: clay + time_needed * c_robots - bp.obsrcc,
             obs: obs + time_needed * obs_robots,
             geodes: geodes + time_needed * g_robots)
      end

      sig { params(bp: Blueprint).returns(SearchStatus) }
      def g_robot_next(bp)
        time_needed = [0, ((bp.groc - ore) / o_robots.to_f).ceil, ((bp.grobsc - obs) / obs_robots.to_f).ceil].max + 1
        with(time: time + time_needed,
             g_robots: g_robots + 1,
             ore: ore + time_needed * o_robots - bp.groc,
             clay: clay + time_needed * c_robots,
             obs: obs + time_needed * obs_robots - bp.grobsc,
             geodes: geodes + time_needed * g_robots)
      end

      sig { returns(Integer) }
      def hash
        [time, o_robots, c_robots, obs_robots, g_robots, ore, clay, obs, geodes].hash
      end
    end

    sig do
      params(bp: Blueprint, t_limit: Integer, status: SearchStatus,
             cache: T::Hash[SearchStatus, Integer], max_cache: Integer).returns(Integer)
    end
    def dfs(bp, t_limit, status, cache, max_cache)
      return cache.fetch(status) if cache.key?(status)

      max_g = status.g_robots * (t_limit - status.time) + status.geodes

      status.next_statuses(bp)
            .reject { |s| (s.pot(t_limit) <= max_g) || (s.pot(t_limit) < max_cache) || (s.time > t_limit) }
            .each do |ns|
        ns.normalise!(bp, t_limit)
        max_g = [max_g, dfs(bp, t_limit, ns, cache, [max_cache, max_g].max)].max
      end

      cache[status] = max_g

      max_g
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 19.
    #
    # @return the answer to part a, day 19.
    def part_a
      @input_lines.map do |line|
        bp = Blueprint.from_string(line)
        bp.id * dfs(bp, 24, SearchStatus.new, {}, 0)
      end.sum
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 19.
    #
    # @return the answer to part B, day 19.
    def part_b
      @input_lines.take(3).map do |line|
        bp = Blueprint.from_string(line)
        dfs(bp, 32, SearchStatus.new, {}, 0)
      end.inject(:*)
    end
  end
end

# sig { params(bp: Blueprint, status: SearchStatus).returns(T::Array[SearchStatus]) }
# def next_statuses(bp, status)
#   ns = status.next_status

#   nss = []

#   prev_o = status.ore - status.o_robots
#   prev_c = status.clay - status.c_robots
#   prev_obs = status.obs - status.obs_robots

#   nss << ns if (status.ore < bp.oroc) || # Can not buy o robot
#                (status.ore < bp.croc) || # Cant buy c robot
#                ((status.ore < bp.obsroc) || (status.clay < bp.obsrcc)) || # Cant buy obs robot
#                ((status.ore < bp.groc) || (status.obs < bp.grobsc)) # Cant buy geode robot

#   if (status.ore >= bp.oroc) && (prev_o < bp.oroc) && (ns.o_robots < bp.max_o_spend)
#     nss << ns.with(o_robots: ns.o_robots + 1, ore: ns.ore - bp.oroc)
#   end
#   if (status.ore >= bp.croc) && (prev_o < bp.croc) && (ns.c_robots < bp.obsrcc)
#     nss << ns.with(c_robots: ns.c_robots + 1, ore: ns.ore - bp.croc)
#   end
#   if (status.ore >= bp.obsroc) && (status.clay >= bp.obsrcc) && ((prev_o < bp.obsroc) || (prev_c < bp.obsrcc)) && (ns.obs_robots < bp.grobsc)
#     nss << ns.with(obs_robots: ns.obs_robots + 1, ore: ns.ore - bp.obsroc, clay: ns.clay - bp.obsrcc)
#   end
#   if (status.ore >= bp.groc) && (status.obs >= bp.grobsc) && ((prev_o < bp.groc) || (prev_obs < bp.grobsc))
#     nss << ns.with(g_robots: ns.g_robots + 1, ore: ns.ore - bp.groc, obs: ns.obs - bp.grobsc)
#   end

#   nss
# end
