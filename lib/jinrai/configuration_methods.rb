module Jinrai #:nodoc:
  module ConfigurationMethods #:nodoc:
    extend ActiveSupport::Concern

    module ClassMethods #:nodoc:

      def cursor_per(num)
        @_default_cursor_per = num.to_i
      end

      def cursor_format(*attributes, &block)
        @_default_cursor_format = attributes
        @_default_attributes_from_cursor = block
      end

      def cursor_sort_at(key)
        @_default_cursor_sort_at = key.to_sym
      end

      def cursor_sort_order(rank)
        @_default_cursor_sort_order = rank.to_sym
      end

      def default_cursor_per
        @_default_cursor_per || Jinrai.config.default_cursor_per
      end

      def default_cursor_format
        @_default_cursor_format || Jinrai.config.default_cursor_format
      end

      def default_cursor_sort_at
        @_default_cursor_sort_at || Jinrai.config.default_cursor_sort_at
      end

      def default_cursor_sort_order
        @_default_cursor_sort_order || Jinrai.config.default_cursor_sort_order
      end

      def default_attributes_from_cursor
        @_default_attributes_from_cursor || Jinrai.config.default_attributes_from_cursor
      end
    end
  end
end
