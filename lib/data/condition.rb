module SQLKnit
  module Data
    class Condition

      attr_reader :left, :op, :right

      def initialize left, op, right
        @left = left
        @op = op
        @right = right
      end

      def and condition
        Condition.new to_s, 'and', condition.to_s
      end

      def or
        Condition.new to_s, 'or', condition.to_s
      end

      def to_s
        [left, op, right].join(' ')
      end
      
    end
  end
end
