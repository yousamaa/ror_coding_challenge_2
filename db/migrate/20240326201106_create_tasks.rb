class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title,        null: false, default: ''
      t.string :description,  null: false, default: ''
      t.string :status
      t.integer :priority
      t.integer :progress
      t.datetime :due_at,     null: false, default: DateTime.now + 7.days
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
