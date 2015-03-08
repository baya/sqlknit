module SQLKnit
  module SQL
    class JoinStatement

      attr_reader :relation, :condition

      def initialize relation, condition
        @relation = relation
        @condition = condition
      end

      def to_s
        ['join', relation, 'on', "(#{condition})"].join(' ')
      end
      
    end
  end
end
