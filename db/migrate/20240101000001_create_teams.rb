class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :slack_webhook_url

      t.timestamps
    end

    add_index :teams, :slug, unique: true
  end
end
