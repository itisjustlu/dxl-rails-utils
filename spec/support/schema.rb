# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :questions, :force => true do |t|
    t.string :title
    t.string :description
    t.json :data
    t.integer :organization_id
    t.timestamps
  end

  create_table :organizations, :force => true do |t|
    t.string :title
    t.json :data
    t.timestamps
  end

  create_table :comments, :force => true do |t|
    t.string :title
    t.integer :organization_id
  end
end
