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
                  :default_cursor_sort_at,
                  :default_cursor_sort_order,
                  :default_attributes_from_cursor

    def initialize
      @default_cursor_per = 20
      @default_cursor_format = [:id]
      @default_cursor_sort_at = :id
      @default_cursor_sort_order = :desc
      @default_attributes_from_cursor = Proc.new { |decoded_cursor| decoded_cursor }
    end
  end
end
