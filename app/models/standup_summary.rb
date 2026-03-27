class StandupSummary < ApplicationRecord
  belongs_to :team

  validates :summary_date, presence: true, uniqueness: { scope: :team_id }
  validates :content, presence: true

  scope :recent, -> { order(summary_date: :desc) }

  def mark_posted_to_slack!
    update!(posted_to_slack: true, posted_to_slack_at: Time.current)
  end
end
