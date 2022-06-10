# frozen_string_literal: true

module DXL
  module AR
    module Concerns
      module Finders
        module Comparison
          def self.included(base)
            base.class_eval do
              extend ClassMethods
              include InstanceMethods
            end
          end

          module ClassMethods
            def find_gte(gte, column: nil)
              @gte ||= []
              @gte.push({ name: gte, column: column || lte })
            end

            def find_gt(gt, column: nil)
              @gt ||= []
              @gt.push({ name: gt, column: column || lte })
            end

            def find_lte(lte, column: nil)
              @lte ||= []
              @lte.push({ name: lte, column: column || lte })
            end

            def find_lt(lt, column: nil)
              @lt ||= []
              @lt.push({ name: lt, column: column || lt })
            end

            def find_eq(*eq)
              @eq ||= eq.flatten
            end

            def find_ilike(*ilike)
              @ilike = ilike.flatten
            end

            def gte
              @gte
            end

            def gt
              @gt
            end

            def lte
              @lte
            end

            def lt
              @lt
            end

            def eq
              @eq || []
            end

            def ilike
              @ilike || []
            end
          end

          module InstanceMethods
            def apply_comparison
              apply_eq
              apply_ilike
              apply_gte
              apply_gt
              apply_lte
              apply_lt
            end

            private

            def apply_eq
              self.class.eq.each do |eq|
                if context.opts["#{eq}_eq".to_sym].present?
                  context.relation = context.relation.where(eq => context.opts["#{eq}_eq".to_sym])
                end
              end
            end

            def apply_ilike
              self.class.ilike.each do |ilike|
                if context.opts["#{ilike}_matching".to_sym].present?
                  context.relation = context.relation.where("#{ilike} ILIKE ?", "%#{context.opts["#{ilike}_matching".to_sym]}%")
                end
              end
            end

            def apply_gte
              return unless self.class.gte.present?

              self.class.gte.each do |gte|
                gte_symbol = "#{gte[:name].to_s.gsub('.', '_')}_gte".to_sym
                if context.opts[gte_symbol].present?
                  context.relation = context.relation.where("#{gte[:column]} >= ?", context.opts[gte_symbol])
                end
              end
            end

            def apply_gt
              return unless self.class.gt.present?

              self.class.gt.each do |gt|
                gt_symbol = "#{gt[:name].to_s.gsub('.', '_')}_gt".to_sym
                if context.opts[gt_symbol].present?
                  context.relation = context.relation.where("#{gt[:column]} > ?", context.opts[gt_symbol])
                end
              end
            end

            def apply_lte
              return unless self.class.lte.present?

              self.class.lte.each do |lte|
                lte_symbol = "#{lte[:name].to_s.gsub('.', '_')}_lte".to_sym
                if context.opts[lte_symbol].present?
                  context.relation = context.relation.where("#{lte[:column]} <= ?", context.opts[lte_symbol])
                end
              end
            end

            def apply_lt
              return unless self.class.lt.present?

              self.class.lt.each do |lt|
                lt_symbol = "#{lt.to_s.gsub('.', '_')}_lt".to_sym
                if context.opts[lt_symbol].present?
                  context.relation = context.relation.where("#{lt} < ?", context.opts[lt_symbol])
                end
              end
            end
          end
        end
      end
    end
  end
end
