# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 16
  class Day16 < Day
    ##
    # A tunnel system
    class TunnelSystem < T::Struct
      extend T::Sig

      prop :nodes, T::Hash[Symbol, Integer]
      prop :edges, T::Hash[Symbol, T::Hash[Symbol, Float]]

      INPUT_LINE = /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.+)/
      VALVE_PATTERN = /\w+/
      STARTING_POINT = :AA

      sig { params(line: T.nilable(String)).void }
      def parse_input(line)
        raise ArgumentError, "No parse: '#{line}'" unless INPUT_LINE =~ line

        store_params(T.must(Regexp.last_match))
      end

      sig { params(time_limit: Integer, n_workers: Integer).returns(Integer) }
      def max_score(time_limit, n_workers)
        st = { pos: STARTING_POINT, t: time_limit, visited: [], score: 0 }
        eps = search_one_worker(time_limit, st)
        max_by_one = eps.map { |ep| ep.fetch(:score) }.max.to_i

        (n_workers - 1).times do
          eps.sort_by! { |ep| ep.fetch(:score) }.reverse!
          max_seen = T.let(nil, T.nilable(Integer))
          next_eps = T.let([], T::Array[T.untyped])
          eps.each do |ep|
            next unless max_seen.nil? || ep.fetch(:score) + max_by_one > max_seen

            this_eps = search_one_worker(time_limit, ep)
            this_score = this_eps.map { |this_ep| this_ep.fetch(:score) }.max.to_i
            max_seen = max_seen.nil? ? this_score : [this_score, max_seen].max
            next_eps += this_eps
          end
          eps = next_eps.flatten
        end
        eps.map { |ep| ep.fetch(:score) }.max.to_i
      end

      sig { void }
      def floyd_warshall
        nodes.keys.product(nodes.keys, nodes.keys) do |k, i, j|
          next if i == j || i == k || [j, k].include?(STARTING_POINT)

          i_edges = edges.fetch(i)
          k_edges = edges.fetch(k)
          dist_via_k = i_edges.fetch(k, Float::INFINITY) + k_edges.fetch(j, Float::INFINITY)
          direct_dist = i_edges.fetch(j, Float::INFINITY)
          i_edges[j] = direct_dist < dist_via_k ? direct_dist : dist_via_k
        end
      end

      sig { void }
      def collapse
        nodes.each { |n, fr| collapse_node(n) if fr.zero? }
        edges.each_value { |edge_list| edge_list.delete(STARTING_POINT) }
      end

      private

      sig do
        params(t_limit: Integer, input_s: T.untyped).returns(T::Array[T::Hash[Symbol, T.untyped]])
      end
      def search_one_worker(t_limit, input_s)
        ini_stat = { pos: STARTING_POINT, t: t_limit, visited: input_s.fetch(:visited), score: input_s.fetch(:score) }
        search_q = T.let([ini_stat], T::Array[T::Hash[Symbol, T.untyped]])
        output = T.let([], T::Array[T::Hash[Symbol, T.untyped]])
        until search_q.empty?
          s = T.must_because(search_q.shift) { "We only loop until the queue is empty." }
          reachable = edges.fetch(s.fetch(:pos)).reject { |n, d| s.fetch(:visited).include?(n) || s.fetch(:t) < d + 1 }
          output.append(s)
          reachable.each do |n, d|
            t = s.fetch(:t) - (d + 1)
            search_q.push({ pos: n, t:, visited: s.fetch(:visited) + [n], score: s.fetch(:score) + nodes.fetch(n) * t })
          end
        end
        output
      end

      sig { params(match_o: MatchData).returns(T::Hash[T.untyped, T.untyped]) }
      def store_params(match_o)
        name = T.must(match_o[1]).to_sym
        nodes[name] = match_o[2].to_i
        tunnels = T.cast(match_o[3]&.scan(VALVE_PATTERN), T::Array[String]).map(&:to_sym)
        edges[name] = tunnels.each_with_object({}) { |t, h| h[t] = 1.0 }
      end

      sig { params(node_name: Symbol).void }
      def collapse_node(node_name)
        edges.fetch(node_name).each.to_a.combination(2) do |p1, p2|
          add_edges(T.cast(p1&.first, Symbol), T.cast(p2&.first, Symbol),
                    T.cast(p1&.last, Float) + T.cast(p2&.last, Float))
        end

        delete_node(node_name) unless node_name == STARTING_POINT
      end

      sig { params(node_name: Symbol).void }
      def delete_node(node_name)
        edges.each_value { |edge_list| edge_list.delete(node_name) }
        edges.delete(node_name)
        nodes.delete(node_name)
      end

      sig { params(node_a: Symbol, node_b: Symbol, dist: Float).void }
      def add_edges(node_a, node_b, dist)
        old_a_to_b = edges.fetch(node_a)[node_b]
        edges.fetch(node_a)[node_b] = old_a_to_b.nil? ? dist : [old_a_to_b, dist].min
        old_b_to_a = edges.fetch(node_b)[node_a]
        edges.fetch(node_b)[node_a] = old_b_to_a.nil? ? dist : [old_b_to_a, dist].min
      end
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 16.
    #
    # @return the answer to part a, day 16.
    def part_a
      t = TunnelSystem.new(nodes: {}, edges: {})
      @input_lines.each { |line| t.parse_input(line) }
      t.collapse
      t.floyd_warshall
      t.max_score(30, 1)
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 16.
    #
    # @return the answer to part B, day 16.
    def part_b
      t = TunnelSystem.new(nodes: {}, edges: {})
      @input_lines.each { |line| t.parse_input(line) }
      t.collapse
      t.floyd_warshall
      t.max_score(26, 2)
    end
  end
end
