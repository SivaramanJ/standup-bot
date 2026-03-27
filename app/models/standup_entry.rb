class StandupEntry < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :yesterday, presence: true
  validates :today, presence: true
  validates :entry_date, presence: true
  validates :user_id, uniqueness: { scope: :entry_date, message: "already submitted an entry for this date" }

  before_validation :set_team_from_user, :set_entry_date, :set_has_blockers

  scope :for_date, ->(date) { where(entry_date: date) }
  scope :with_blockers, -> { where(has_blockers: true) }
  scope :recent, -> { order(created_at: :desc) }

  private

  def set_team_from_user
    self.team ||= user&.team
  end

  def set_entry_date
    self.entry_date ||= Date.current
  end

  def set_has_blockers
    self.has_blockers = blockers.present?
  end
end
