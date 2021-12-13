# frozen_string_literal: true

class CreateRakesOneTimers < ActiveRecord::Migration[6.0]
  def change
    create_table :rakes_one_timers do |t|
      t.string :name

      t.timestamps
    end

    add_index :rakes_one_timers, :name
  end
end
