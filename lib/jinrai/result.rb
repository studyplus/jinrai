module Jinrai
  module Result
    attr_writer :is_cursored

    def initialize(*a)
      @is_cursored = false
      super(*a)
    end

    def cursored?
      @is_cursored
    end
  end
end
