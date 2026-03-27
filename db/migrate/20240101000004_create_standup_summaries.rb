class CreateStandupSummaries < ActiveRecord::Migration[7.2]
  def change
    create_table :standup_summaries do |t|
      t.references :team, null: false, foreign_key: true
      t.date :summary_date, null: false
      t.text :content, null: false
      t.boolean :posted_to_slack, default: false, null: false
      t.datetime :posted_to_slack_at
      t.integer :entry_count, default: 0, null: false

      t.timestamps
    end

    add_index :standup_summaries, [:team_id, :summary_date], unique: true
  end
end
