class StandupEntriesController < ApplicationController
  def new
    @entry = StandupEntry.new(entry_date: Date.current)
    @users = @current_team.users.order(:name)
    @today_entries = @current_team.entries_for(Date.current).includes(:user)
    @today_summary = @current_team.standup_summaries.find_by(summary_date: Date.current)
  end

  def create
    @entry = StandupEntry.new(entry_params)
    @entry.team = @current_team

    if @entry.save
      redirect_to new_standup_entry_path,
        notice: "Thanks #{@entry.user.name}! Your standup has been submitted."
    else
      @users = @current_team.users.order(:name)
      @today_entries = @current_team.entries_for(Date.current).includes(:user)
      @today_summary = @current_team.standup_summaries.find_by(summary_date: Date.current)
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @entries = @current_team.entries_for(@date).includes(:user)
    @summary = @current_team.standup_summaries.find_by(summary_date: @date)
  end

  private

  def entry_params
    params.require(:standup_entry).permit(:user_id, :yesterday, :today, :blockers, :entry_date)
  end
end
