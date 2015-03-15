module SQLKnit
  module SQL
    class Where

      EnumList = Data::EnumList
      Condition = Data::Condition
      
      attr_reader :conditions, :op, :conj

      def initialize
        @conditions = []
        @op = '='
        @conj = 'and'
      end

      def con op, &block
        @op = op
        instance_eval &block if block_given?
        @op = '='
      end

      def to_s
        ['where', conditions.last.to_s].join(' ')
      end

      private

      def method_missing relation, condition_mapper, &block
        create_method relation do |condition_mapper|
          condition_mapper.each {|k, v|
            left = "#{relation}.#{k}"
            
            if v.is_a? Symbol
              right = v
            elsif v.is_a? Enumerable
              right = EnumList.new v
            elsif v.is_a? Numeric
              right = v
            else
              right = "'#{v}'"
            end

            condition = Condition.new left, op, right
            if conditions.empty?
              conditions << condition
            else
              conditions << conditions.last.send(conj, condition)
            end  
            
          }
        end

        send relation, condition_mapper
      end
      
      def create_method name, &block
        self.class.send :define_method, name, &block
      end
      
    end
  end
end
