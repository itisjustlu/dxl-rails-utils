# frozen_string_literal: true

require 'rails/generators'

module TalentHack
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=rails_utils'
      end

      def run_migrations
        res = ask 'Would you like to run the migrations now? [Y/n]'
        if res == '' || res.downcase == 'y'
          run 'bundle exec rails db:migrate'
        else
          puts 'Skipping rails db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
