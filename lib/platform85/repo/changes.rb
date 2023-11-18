module Platform85
  module Repo
    class Changes
      def initialize(object, attrs:)
        @object = object
        @attrs = attrs
        @origin_values = {}
      end

      def changed?(attr)
        return true unless @origin_values.key? attr

        @origin_values[attr] != @object.send(attr)
      end

      def commit
        @origin_values = {}
        @attrs.each do |attr|
          @origin_values[attr] = @object.send(attr)
        end
      end
    end
  end
end
