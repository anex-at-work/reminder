# frozen_string_literal: true

class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.references :user, foreign_key: true, on_delete: :cascade
      t.string :title, null: false, default: ''
      t.text :description, null: true
      t.date :date_at, null: true # day exactly
      t.time :time_at, null: false, default: '12:00'
      t.string :user_date, null: true, default: '' # human input value, such as '1st day'
      t.jsonb :calculated_date, null: true, default: nil
      t.integer :repeat_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
