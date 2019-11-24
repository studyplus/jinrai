require 'jinrai/config'

module Jinrai
  module ActiveRecord
    module CursorMethods
      include Jinrai::ConfigurationMethods

      def since_cursor
        return unless first
        encode_cursor(first)
      end
      alias prev_cursor since_cursor

      def till_cursor
        return unless last
        encode_cursor(last)
      end
      alias next_cursor till_cursor

      def per(num = nil)
        num ||= default_cursor_per
        if (n = num.to_i).negative? || !(/^\d/ =~ num.to_s)
          self
        else
          self.is_cursored = true
          limit(n)
        end
      end

      private

      def encode_cursor(record)
        attributes = default_cursor_format.map do |attr|
          value = record.send(attr)
          value.respond_to?(:iso8601) ? value.iso8601 : value
        end
        Base64.urlsafe_encode64(attributes.join("_"))
      end
    end
  end
end
