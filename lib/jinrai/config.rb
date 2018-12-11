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
                  :default_cursor_sort_order

    def initialize
      @default_cursor_per = 20
      @default_cursor_format = %i[created_at id]
      @default_cursor_sort_order = :desc
    end
  end
end
