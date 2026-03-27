class CreateStandupEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :standup_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.date :entry_date, null: false
      t.text :yesterday, null: false
      t.text :today, null: false
      t.text :blockers
      t.boolean :has_blockers, default: false, null: false

      t.timestamps
    end

    add_index :standup_entries, [:user_id, :entry_date], unique: true
    add_index :standup_entries, [:team_id, :entry_date]
  end
end
