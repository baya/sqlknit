module SQLKnit
  module SQL
    class Join

      RelationAbbrSymbol = ':'
      ValidTypes = ['right', 'left', 'inner', 'full']
   
      attr_reader :statement_chains, :type, :name
      
      def initialize opts = {}
        type = opts[:type]
        @type = type.nil? ? 'inner' : type.downcase
        validate_type
        @statement_chains = []
        @name = [type, 'join'].join(' ')
      end

      def validate_type
        raise "Invalid join type: #{type}" if not ValidTypes.include?(type)
      end

      def text str, *args
        statement = str
        args.each {|arg|
          statement = statement.sub(/\?/, arg.to_s)
        }
        statement = [name, statement].join(' ')
        statement_chains << statement if not statement_chains.include? statement
      end

      def to_statement
        statement_chains.join("\n")
      end

      private
      
      def method_missing relation_name, *args
        create_method relation_name do |*args|
          if args.size > 1
            aname, conditions = args
          else
            conditions = args.last
          end

          if aname
            on = parse_on aname, conditions
          else
            on = parse_on relation_name, conditions
          end

          text [relation_name, aname, "on", "(#{on})"].compact.join(' ')
        end

        send relation_name, *args
      end

      def parse_on relation_name, conditions
        on = conditions[:on]
        if on.is_a? String
          on.sub(":.", "#{relation_name}.")
        end
      end

      def create_method name, &block
        self.class.send :define_method, name, &block
      end

    end
  end
end
