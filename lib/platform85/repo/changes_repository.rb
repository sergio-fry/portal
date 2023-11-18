require "platform85/repo/changes"

module Platform85
  module Repo

    class ChangesRepository
      def initialize(attrs:)
        @changes = {}
        @attrs = attrs
      end

      def for(object)
        @changes[object.id] ||= Changes.new(object, attrs: @attrs)
      end
    end
  end
end

