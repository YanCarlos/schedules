class CreateEvent < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.date :starts_at
      t.date :ends_at
    end
  end
end
