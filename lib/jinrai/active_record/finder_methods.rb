require 'jinrai/active_record/cursor_methods'

module Jinrai
  module ActiveRecord #:nodoc:
    module FinderMethods
      extend ActiveSupport::Concern

      included do
        include Jinrai::ConfigurationMethods
      end

      module ClassMethods
        def cursor(**options)
          sort_order = options[:sort_order] || default_cursor_sort_order
          relation =
            if sort_order == :desc
              cursoring(:lt, :gt, options[:since], options[:sort_at]).cursoring(:gt, :lt, options[:till], options[:sort_at])
            elsif sort_order == :asc
              cursoring(:gt, :lt, options[:since], options[:sort_at]).cursoring(:lt, :gt, options[:till], options[:sort_at])
            end
          relation.extending_cursor
        end

        def after(cursor, **options)
          sort_order = options[:sort_order] || default_cursor_sort_order
          relation =
            if sort_order == :desc
              cursoring(:lt, :gt, cursor, options[:sort_at])
            elsif sort_order == :asc
              cursoring(:gt, :lt, cursor, options[:sort_at])
            end
          relation.extending_cursor
        end

        def before(cursor, **options)
          sort_order = options[:sort_order] || default_cursor_sort_order
          relation =
            if sort_order == :desc
              cursoring(:gt, :lt, cursor, options[:sort_at])
            elsif sort_order == :asc
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
            attributes = default_attributes_from_cursor.call(decode_cursor(cursor))
            pointed = find_by!(attributes)

            if sort_at != primary_key
              condition_1 = arel_table[sort_at].send(rank, pointed[sort_at])
              condition_2 = arel_table.grouping(arel_table[sort_at].eq(pointed[sort_at]).and(arel_table[primary_key].send(rank_for_primary, pointed[primary_key])))
              relation = where(condition_1.or(condition_2))
            else
              relation = where(arel_table[primary_key].send(rank, pointed[primary_key]))
            end
          else
            relation = all
          end
          relation.order(sort_at => default_cursor_sort_order)
        rescue ::ActiveRecord::StatementInvalid => e
          # TODO: modify error message
          raise Jinrai::ActiveRecord::StatementInvalid, e
        rescue ::ActiveRecord::RecordNotFound
          raise Jinrai::ActiveRecord::RecordNotFound,
            "Could not find record cursor pointing, Check cursor_format settings."
        end

        private

        def decode_cursor(cursor)
          attributes = Base64.urlsafe_decode64(cursor).split("_")
          HashWithIndifferentAccess.new(default_cursor_format.zip(attributes).to_h)
        end
      end
    end
  end
end
