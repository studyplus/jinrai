module Jinrai
  module ActiveRecord
    module Result
      attr_writer :is_cursored

      def initialize(klass, **args)
        @is_cursored = false
        super
      end

      def cursored?
        @is_cursored
      end
    end
  end
end
