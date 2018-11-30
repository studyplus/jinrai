require 'jinrai/active_record/cursor_methods'

module Jinrai::ActiveRecord
  module FinderMethods
    extend ActiveSupport::Concern

    included do
      include Jinrai::ConfigurationMethods
    end

    module ClassMethods

      def cursor(**options)
        relation =
          if default_cursor_sort_order == :desc
            cursoring(:lt, :gt, options[:since], options[:sort_at]).cursoring(:gt, :lt, options[:till], options[:sort_at])
          elsif default_cursor_sort_order == :asc
            cursoring(:gt, :lt, options[:since], options[:sort_at]).cursoring(:lt, :gt, options[:till], options[:sort_at])
          end
        relation.extending_cursor
      end

      def after(cursor, **options)
        relation =
          if default_cursor_sort_order == :desc
            cursoring(:lt, :gt, cursor, options[:sort_at])
          elsif default_cursor_sort_order == :asc
            cursoring(:gt, :lt, cursor, options[:sort_at])
          end
        relation.extending_cursor
      end

      def before(cursor, **options)
        relation =
          if default_cursor_sort_order == :desc
            cursoring(:gt, :lt, cursor, options[:sort_at])
          elsif default_cursor_sort_order == :asc
            cursoring(:lt, :gt, cursor, options[:sort_at])
          end
        relation.extending_cursor
      end

      def extending_cursor
        extending { include Jinrai::ActiveRecord::CursorMethods }.per
      end


      def cursoring(rank, rank_for_primary, cursor, sort_at)
        sort_at ||= primary_key
        if cursor
          attributes = HashWithIndifferentAccess.new(decode_cursor(cursor))
          id = default_cursor_record_id_extractor.call(self, attributes)

          if sort_at != primary_key
            condition_1 = arel_table[sort_at].send(rank, attributes[sort_at])
            condition_2 = arel_table.grouping(arel_table[sort_at].eq(attributes[sort_at]).and(arel_table[primary_key].send(rank_for_primary, id)))
            relation = where(condition_1.or(condition_2))
          else
            relation = where(arel_table[primary_key].send(rank, id))
          end
        else
          relation = all
        end
        relation.order(sort_at => default_cursor_sort_order)
      end

      private

      def decode_cursor(cursor)
        attributes = Base64.urlsafe_decode64(cursor).split("_")
        default_cursor_format.zip(attributes).to_h
      end
    end
  end
end
