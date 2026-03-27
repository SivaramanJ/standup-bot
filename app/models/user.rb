class User < ApplicationRecord
  belongs_to :team
  has_many :standup_entries, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: :team_id },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  def today_entry
    standup_entries.find_by(entry_date: Date.current)
  end

  def submitted_today?
    today_entry.present?
  end
end
