class StandupSummariesController < ApplicationController
  def show
    @summary = @current_team.standup_summaries.find(params[:id])
    @entries = @current_team.entries_for(@summary.summary_date).includes(:user)
  end

  def generate
    date = params[:date] ? Date.parse(params[:date]) : Date.current
    entries = @current_team.entries_for(date).includes(:user)

    if entries.empty?
      return redirect_to new_standup_entry_path,
        alert: "No standup entries found for #{date.strftime('%B %-d')}. Ask your team to submit first."
    end

    # Regenerate if one already exists for this date
    existing = @current_team.standup_summaries.find_by(summary_date: date)

    begin
      content = ClaudeSummaryService.new(entries).generate

      summary = if existing
        existing.update!(content: content, entry_count: entries.count)
        existing
      else
        @current_team.standup_summaries.create!(
          summary_date: date,
          content: content,
          entry_count: entries.count
        )
      end

      # Optionally post to Slack
      if params[:post_to_slack] == "1" && @current_team.slack_webhook_url.present?
        SlackNotificationService.new(@current_team.slack_webhook_url).post_summary(summary)
        summary.mark_posted_to_slack!
        flash[:notice] = "Summary generated and posted to Slack!"
      else
        flash[:notice] = "Summary generated successfully!"
      end

      redirect_to standup_summary_path(summary)

    rescue => e
      Rails.logger.error "Summary generation failed: #{e.message}"
      redirect_to standup_entries_path(date: date),
        alert: "Failed to generate summary: #{e.message}"
    end
  end
end
