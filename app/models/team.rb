class Team < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :standup_entries, dependent: :destroy
  has_many :standup_summaries, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/ }

  before_validation :generate_slug, on: :create

  def latest_summary
    standup_summaries.order(summary_date: :desc).first
  end

  def entries_for(date)
    standup_entries.where(entry_date: date).includes(:user)
  end

  private

  def generate_slug
    self.slug ||= name.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
  end
end
