module SQLKnit
  module SQL
    class JoinStatement

      attr_reader :type, :relation, :condition
      attr_reader :type_join

      def initialize(type, relation, condition)
        @relation = parse_relation(relation)
        @condition = condition
        @type = type
        @type_join = [type, 'join'].compact.join(' ')
      end

      def parse_relation(relation)
        if relation.is_a?(Hash)
          relation.map {|k, v| "#{k} #{v}"}.join(', ')
        else
          relation
        end
      end

      def to_s
        [type_join, relation, 'on', "(#{condition})"].join(' ')
      end
      
    end
  end
end
