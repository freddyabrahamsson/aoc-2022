# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 07
  class Day07 < Day
    DIR_PATTERN = /^dir (\S+)$/ # A dir is printed as 'dir DIRNAME'
    FILE_PATTERN = /^(\d+) (\S+)$/ # A file is printed as 'FILESIZE FILENAME'
    CMD_LS_PATTERN = /^\$ ls/ # Pattern of an ls command
    CMD_CD_PATTERN = /^\$ cd (\S+)/ # Pattern of a cd command

    ##
    # A node in the file tree
    class FSNode
      extend T::Sig
      extend T::Helpers
      abstract!

      sig { returns(String) }
      ##
      # The name of the node.
      #
      # @return the name of the node
      attr_reader :name

      sig { returns(T.nilable(AoCDir)) }
      ##
      # Get the parent of this node, unless this is the root node.
      #
      # @return the parent node of this node
      attr_reader :parent

      sig { params(name: String, parent: T.nilable(AoCDir)).void }
      def initialize(name, parent)
        @name = name
        @parent = parent
      end

      sig { abstract.returns(Integer) }
      def size; end

      sig { returns(String) }
      ##
      # Get the absolute path to this node
      #
      # @return absolute path
      def abs_path
        return FS::ROOT_PATH unless parent

        "#{T.must(parent).abs_path}/#{name}".sub("//", "/")
      end
    end

    ##
    # A File
    class AoCFile < FSNode
      sig { override.returns(Integer) }
      attr_reader :size

      sig { params(name: String, size: Integer, parent: AoCDir).void }
      def initialize(name, size, parent)
        super(name, parent)
        @size = size
      end
    end

    ##
    # A directory
    class AoCDir < FSNode
      extend T::Sig

      sig { returns(T::Hash[String, FSNode]) }
      attr_reader :content

      sig { params(name: String, parent: T.nilable(AoCDir)).void }
      def initialize(name, parent)
        super(name, parent)
        @content = T.let({}, T::Hash[String, FSNode])
      end

      sig { override.returns(Integer) }
      ##
      # Get the total size of the director, including subdirectories.
      #
      # @return total size
      def size
        @content.values.map(&:size).sum
      end
    end

    ##
    # A filesystem
    class FS
      extend T::Sig

      TOTAL_SIZE = 70_000_000 # Total size of a file system
      ROOT_PATH = "/" # Root path in a file system

      sig { returns(T::Hash[String, FSNode]) }
      attr_reader :nodes

      sig { void }
      def initialize
        @current_dir = T.let(AoCDir.new("", nil), AoCDir)
        @nodes = T.let({ "/" => @current_dir }, T::Hash[String, FSNode])
      end

      sig { params(lls: T::Array[String]).returns(FS) }
      ##
      # Read a file system from a shell history
      #
      # @param lls lines in the log
      # @return a file system
      def self.from_log(lls)
        loc_lls = lls.dup
        fs = FS.new
        until loc_lls.empty?
          ll = loc_lls.shift
          if CMD_CD_PATTERN =~ ll
            fs.cd T.must(Regexp.last_match(1))
          elsif CMD_LS_PATTERN =~ ll
            fs.read_ls_line(T.must(loc_lls.shift)) until loc_lls.empty? || (loc_lls.first&.start_with? "$")
          end
        end
        fs
      end

      sig { params(path: String).void }
      ##
      # Execute a cd command.
      #
      # @param path new path
      def cd(path)
        new_path = File.absolute_path(path, @current_dir.abs_path)
        self.current_dir = T.cast(@nodes[new_path], AoCDir)
      end

      sig { params(line: String).void }
      ##
      # Read a node from an output line from the ls command and insert it.
      #
      # @param line output line from ls
      def read_ls_line(line)
        new_node = node_from_ls_line(line)
        @current_dir.content[new_node.name] = new_node
        new_path = "#{@current_dir.abs_path}/#{new_node.name}".gsub("//", "/")
        @nodes[new_path] = new_node
      end

      sig { params(line: T.nilable(String)).returns(T.any(Days::Day07::AoCDir, Days::Day07::AoCFile)) }
      ##
      # Parse a node from an ls line
      #
      # @param line output from ls
      # @return an FSNode object
      def node_from_ls_line(line)
        if DIR_PATTERN =~ line
          new_name = T.must(Regexp.last_match(1))
          AoCDir.new(new_name, @current_dir)
        elsif FILE_PATTERN =~ line
          new_size = T.must(Regexp.last_match(1)).to_i
          new_name = T.must(Regexp.last_match(2))
          AoCFile.new(new_name, new_size, @current_dir)
        else
          raise ArgumentError, "Could not parse line: #{line}"
        end
      end

      sig { returns(Integer) }
      ##
      # Get the amount of free space on the system.
      #
      # @return free space
      def free_space
        TOTAL_SIZE - T.must(@nodes[ROOT_PATH]).size
      end

      sig { params(current_dir: AoCDir).void }
      attr_writer :current_dir
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 07.
    #
    # @return the answer to part a, day 07.
    def part_a
      fs = FS.from_log(@input_lines)
      fs.nodes.values.filter { |node| node.size <= 100_000 && node.is_a?(AoCDir) }.map(&:size).sum
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 07.
    #
    # @return the answer to part B, day 07.
    def part_b
      needed_space = 30_000_000
      fs = FS.from_log(@input_lines)
      to_be_freed = needed_space - fs.free_space
      candidates = fs.nodes.values.filter { |node| node.size >= to_be_freed && node.is_a?(AoCDir) }
      T.must(candidates.sort_by!(&:size).map!(&:size).first)
    end
  end
end
