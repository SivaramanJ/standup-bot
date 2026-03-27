class ApplicationController < ActionController::Base
  before_action :set_current_team

  def logger
    Rails.logger
  end

  private

  # In a real app this would come from auth. For now we use a single default team.
  def set_current_team
    @current_team = Team.first_or_create!(
      name: "Engineering",
      slug: "engineering"
    )
  end
end
