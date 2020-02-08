class CreateSchedule < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :event, foreign_key: true, index: true
      t.integer :day
      t.time :time
    end
  end
end
