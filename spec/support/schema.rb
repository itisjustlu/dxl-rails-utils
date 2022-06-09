# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :questions, :force => true do |t|
    t.string :title
    t.string :description
    t.integer :organization_id
    t.timestamps
  end

  create_table :organizations, :force => true do |t|
    t.string :title
    t.timestamps
  end
end
