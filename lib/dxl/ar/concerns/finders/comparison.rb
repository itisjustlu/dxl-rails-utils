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
            def find_eq(*eq)
              @eq ||= []
              @eq.concat(eq.flatten)
            end

            def find_not_eq(*not_eq)
              @not_eq ||= []
              @not_eq.concat(not_eq.flatten)
            end

            def find_ilike(*ilike)
              @ilike ||= []
              @ilike.concat(ilike.flatten)
            end

            def find_gte(field, column: nil)
              @gte ||= []
              @gte.push({ name: field, column: column || field })
            end

            def find_gt(field, column: nil)
              @gt ||= []
              @gt.push({ name: field, column: column || field })
            end

            def find_lte(field, column: nil)
              @lte ||= []
              @lte.push({ name: field, column: column || field })
            end

            def find_lt(field, column: nil)
              @lt ||= []
              @lt.push({ name: field, column: column || field })
            end

            def eq = @eq || []
            def not_eq = @not_eq || []
            def ilike = @ilike || []
            def gte = @gte || []
            def gt = @gt || []
            def lte = @lte || []
            def lt = @lt || []

            # Returns a hash of { accepted_opts_key => ransack_key }.
            # Includes legacy aliases so old callers don't need to change.
            def comparison_key_map
              map = {}
              eq.each      { |f| map["#{f}_eq"]       = "#{f}_eq" }
              not_eq.each  { |f| map["#{f}_not_eq"]   = "#{f}_not_eq" }
              ilike.each   { |f| map["#{f}_i_cont"]   = "#{f}_i_cont"
                                 map["#{f}_matching"]  = "#{f}_i_cont" }   # legacy
              gte.each     { |f| map["#{f[:name]}_gteq"] = "#{f[:name]}_gteq"
                                 map["#{f[:name]}_gte"]  = "#{f[:name]}_gteq" } # legacy
              gt.each      { |f| map["#{f[:name]}_gt"]   = "#{f[:name]}_gt" }
              lte.each     { |f| map["#{f[:name]}_lteq"] = "#{f[:name]}_lteq"
                                 map["#{f[:name]}_lte"]  = "#{f[:name]}_lteq" } # legacy
              lt.each      { |f| map["#{f[:name]}_lt"]   = "#{f[:name]}_lt" }
              map
            end
          end

          module InstanceMethods
            def apply_comparison
              mapping = self.class.comparison_key_map
              return if mapping.empty?

              ransack_params = context.opts.each_with_object({}) do |(key, value), hash|
                next if value.nil? || value == ''
                ransack_key = mapping[key.to_s]
                next unless ransack_key

                hash[ransack_key] = value
              end

              return if ransack_params.empty?

              context.relation = context.relation.ransack(ransack_params).result
            end
          end
        end
      end
    end
  end
end
