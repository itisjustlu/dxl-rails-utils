# frozen_string_literal: true

require 'talent_hack'

module TalentHack
  class Engine < Rails::Engine

    isolate_namespace TalentHack
    engine_name 'talent_hack'

    def self.activate
    end
  end
end