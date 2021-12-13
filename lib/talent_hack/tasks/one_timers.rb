# frozen_string_literal: true

require 'rake'
require 'talent_hack/models/rakes/one_timer'

namespace :one_timers do
  desc "Run one timer tasks automatically"
  task execute: :environment do
    dirs = Dir["#{Rails.root}/lib/tasks/one_timers/*.rake"]
    tasks = dirs.map { |dir| dir.split('/').last.gsub('.rake', '') }.map { |task| "one_timers:#{task}" }
    db_tasks = ::TalentHack::Rakes::OneTimer.all.pluck(:name)
    tasks = tasks.select { |task| db_tasks.exclude?(task) }

    tasks.each do |task|
      puts "Executing #{task}"
      Rake::Task[task].invoke
      ::TalentHack::Rakes::OneTimer.create(name: task)
      puts "Finished #{task}"
    end
  end
end
