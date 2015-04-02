module SQLKnit
  module SQL
    class From

      attr_reader :statements
      
      def initialize
        @statements = []
      end

      def contextlize(args, &block)
        args.each {|relation|
          if relation.is_a?(Hash)
            relation.each {|k, v|
              statement = FromStatement.new("#{k} #{v}")
              @statements << statement
            }
          else
            statement = FromStatement.new(relation)
            @statements << statement
          end
          
        }
        instance_eval &block if block_given?
      end

      def join(relation, opt={}, &block)
        join = Join.new(nil, relation, opt, &block)
        statement = statements.last
        if statement
          statement.add join.to_statement
        end
      end

      def left_join(relation, opt={}, &block)
        if relation.is_a?(Hash)
          opt = {}
          opt[:on] = relation.delete(:on)
        end
        
        join = Join.new('left', relation, opt, &block)
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
