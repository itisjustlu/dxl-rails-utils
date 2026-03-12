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

                ransack_key, value = normalize_for_ransack(ransack_key, value)
                hash[ransack_key] = value
              end

              return if ransack_params.empty?

              context.relation = context.relation.ransack(ransack_params).result
            end

            private

            def normalize_for_ransack(key, value)
              key_s = key.to_s

              # _not_eq must be checked BEFORE _eq since it also ends with '_eq'
              if key_s.end_with?('_not_eq')
                field = key_s.delete_suffix('_not_eq')
                return ["#{field}_not_in", cast_enum_values(value, field)] if value.is_a?(Array)

                return [key, cast_enum_value(value, field)]
              end

              if key_s.end_with?('_eq')
                field = key_s.delete_suffix('_eq')
                return ["#{field}_in", cast_enum_values(value, field)] if value.is_a?(Array)

                return [key, cast_enum_value(value, field)]
              end

              [key, value]
            end

            def enum_map_for(field)
              klass = context.object_class || context.relation.klass

              # Direct attribute on the model
              return klass.defined_enums[field] if klass.defined_enums.key?(field)

              # Joined table field like 'questions_status' — look up the association's enum
              klass.reflect_on_all_associations.each do |assoc|
                assoc_name = assoc.name.to_s
                next unless field.start_with?("#{assoc_name}_")

                attr = field.delete_prefix("#{assoc_name}_")
                enum_map = assoc.klass.defined_enums[attr]
                return enum_map if enum_map
              end

              nil
            end

            def cast_enum_value(value, field)
              enum_map = enum_map_for(field)
              return value unless enum_map

              enum_map[value.to_s] || value
            end

            def cast_enum_values(values, field)
              values.map { |v| cast_enum_value(v, field) }
            end
          end
        end
      end
    end
  end
end
