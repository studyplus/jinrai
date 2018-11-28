module Jinrai::ActiveRecord
  module Result
    attr_accessor :sort_at
    attr_writer :is_cursored

    def initialize(*)
      @is_cursored = false
      @sort_at = nil
      super
    end

    def cursored?
      @is_cursored
    end

    def since_cursor
      cursor_value = @sort_at ? first.send(@sort_at) : first.send(:created_at)
      Base64.encode64("#{cursor_value}_#{first.send(:hashid)}")
    end

    def till_cursor
      cursor_value = @sort_at ? last.send(@sort_at) : last.send(:created_at)
      Base64.encode64("#{cursor_value}_#{last.send(:hashid)}")
    end
  end

  ::ActiveRecord::Relation.send(:prepend, CursorHelper)
end
