# frozen_string_literal:true

module Jinrai #:nodoc:
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end

  class Config #:nodoc:
    attr_accessor :default_cursor_per,
                  :default_cursor_format,
                  :default_cursor_record_id_extractor,
                  :default_cursor_sort_order

    def initialize
      @default_cursor_per = 20
      @default_cursor_format = %i[created_at id]
      @default_cursor_record_id_extractor = default_id_extractor
      @default_cursor_sort_order = :desc
    end

    # passed attributes; [kls, attributes]
    def default_id_extractor(&block)
      @default_id_extractor =
        if block_given?
          block
        else
          lambda { |kls, attributes| attributes[:id] }
        end
    end
  end

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

      def cursor_record_id_extractor(&block)
        @_default_corsor_id_extractor = block
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

      def default_cursor_record_id_extractor
        @_default_cursor_primary_value || Jinrai.config.default_id_extractor
      end
    end
  end
end
