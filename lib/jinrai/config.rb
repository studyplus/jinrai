module Jinrai
  module ClassMethods
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end

  class Config
    attr_accessor :default_cursor_per
    attr_writer :default_cursor_format

    def intialize
      @default_cursor_per = 25
      @default_cursor_format = [:created_at, :id]
    end
  end
end
