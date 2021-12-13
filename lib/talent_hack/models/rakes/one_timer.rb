# frozen_string_literal: true

require 'active_record/base'

module TalentHack
  module Rakes
    class OneTimer < ActiveRecord::Base
      self.table_name = 'rakes_one_timers'
    end
  end
end
