module SQLKnit
  module SQL
    class From

      attr_reader :statements
      
      def initialize
        @statements = []
      end

      def contextlize args, &block
        args.each {|relation|
          statement = FromStatement.new relation
          @statements << statement
        }
        instance_eval &block if block_given?
      end

      def join *args, &block
        join = Join.new *args, &block
        statement = statements.last
        if statement
          statement.add join.to_statement
        end
      end

      def to_s
        if statements.length > 0
          ["from",
           statements.map(&:to_s).join(",\n")
          ].join(" ")
        end
      end

    end
  end
end
