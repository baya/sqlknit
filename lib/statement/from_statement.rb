module SQLKnit
  module SQL
    class FromStatement

      attr_reader :relation, :join_nodes

      def initialize relation, join_nodes = []
        @relation = relation
        @join_nodes = join_nodes
      end

      def add join_node
        @join_nodes << join_node
      end

      def to_s
        [relation, join_nodes.map(&:to_s)].flatten.join("\n")
      end

    end
  end
end
