module SQLKnit
  module SQL
    class Join

      EnumList = Data::EnumList

      attr_reader :type, :relation, :condition
      
      def initialize type, relation, opts = {}, &block
        @type = type
        @relation = relation
        @condition = opts[:on]
        instance_eval &block if block_given?
      end

      def to_statement
        JoinStatement.new type, relation, condition
      end

      private
      
      def method_missing relation, condition_mapper
        create_method relation do |condition_mapper|
          @condition = condition_mapper.map {|k, v|
            col = "#{relation}.#{k}"
            op = '='
            
            if v.is_a? Symbol
            elsif v.is_a? Enumerable
              v = EnumList.new v
              op = 'in'
            else
              v = "'#{v}'"
            end
            
            [col, op, v].join(' ')
          }.join(' and ')
        end

        send relation, condition_mapper
      end

      def create_method name, &block
        self.class.send :define_method, name, &block
      end

    end
  end
end
