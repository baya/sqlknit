module SQLKnit
  module Data

    class EnumList

      include Enumerable
      
      attr_reader :list
      def initialize list
        @list = list
      end

      def each &block
        list.each &block
      end

      def value
        map {|item|
          case item
          when Numeric; item
          when String; "'#{item}'"
          else
            "'#{item}'"
          end
        }.join(',')
      end


      def to_s
        "(#{value})"
      end

      
    end
    
  end
end
