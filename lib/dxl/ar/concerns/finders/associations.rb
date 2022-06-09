# frozen_string_literal: true

module DXL
  module AR
    module Concerns
      module Finders
        module Associations
          def self.included(base)
            base.class_eval do
              extend ClassMethods
              include InstanceMethods
            end
          end

          module ClassMethods
            def associating(*associated)
              @associated ||= associated.flatten
            end

            def including(*includes)
              @includes = includes.flatten
            end

            def joining(join)
              @join = join
            end

            def left_joining(join)
              @left_join = join
            end

            def associated
              @associated || []
            end

            def includes
              @includes || []
            end

            def join
              @join
            end

            def left_join
              @left_join
            end
          end

          module InstanceMethods
            def apply_associations
              apply_associated
              apply_includes
              apply_join
              apply_left_join
            end

            def apply_associated
              self.class.associated.each do |association|
                if context.opts["with_#{association}".to_sym].to_s == 'true'
                  context.relation = context.relation.where.associated(association).distinct
                end
              end
            end

            def apply_left_join
              return unless self.class.left_join.present?

              context.relation = context.relation.left_joins(self.class.left_join)
            end

            def apply_join
              return unless self.class.join.present?

              context.relation = context.relation.joins(self.class.join)
            end

            def apply_includes
              return unless self.class.includes.present?

              context.relation = context.relation.includes(self.class.includes)
            end
          end
        end
      end
    end
  end
end
