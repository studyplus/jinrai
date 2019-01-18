module Jinrai #:nodoc:
  module ConfigurationMethods #:nodoc:
    extend ActiveSupport::Concern

    module ClassMethods #:nodoc:

      def cursor_per(num)
        @_default_cursor_per = num.to_i
      end

      def cursor_format(*attributes)
        @_default_cursor_format = attributes
      end

      def cursor_sort_order(rank)
        @_default_cursor_sort_order = rank.to_sym
      end

      def attributes_from_cursor(&block)
        @_default_attributes_from_cursor = block
        
      end

      def default_cursor_per
        @_default_cursor_per || Jinrai.config.default_cursor_per
      end

      def default_cursor_format
        @_default_cursor_format || Jinrai.config.default_cursor_format
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
