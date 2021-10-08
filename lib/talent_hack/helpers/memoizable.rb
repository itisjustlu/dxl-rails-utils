# frozen_string_literal: true

module TalentHack
  module Helpers
    module Memoizable
      def memoize
        method_name = caller[0][/`.*'/][1..-2]
        instance_var_str = "@#{method_name}".to_sym
        return instance_variable_get(instance_var_str) if instance_variable_defined?(instance_var_str)
        instance_variable_set(instance_var_str, yield)
      end
    end
  end
end
