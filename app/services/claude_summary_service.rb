class ClaudeSummaryService
  MODEL = "claude-opus-4-6"

  def initialize(entries)
    @entries = entries
    @client = Anthropic::Client.new
  end

  # Returns the generated summary string, raises on failure
  def generate
    raise ArgumentError, "No entries provided" if @entries.empty?

    response = @client.messages.create(
      model: MODEL,
      max_tokens: 2048,
      thinking: { type: "adaptive" },
      system: system_prompt,
      messages: [
        { role: "user", content: build_user_message }
      ]
    )

    extract_text(response)
  end

  private

  def system_prompt
    <<~PROMPT
      You are a helpful engineering team assistant that synthesizes daily standup updates into
      clear, readable summaries for team leads and managers.

      Your summaries should:
      - Be concise and well-organized with clear sections
      - Group related work together when team members are working on the same area
      - Highlight blockers prominently so they are easy to spot
      - Use a friendly, professional tone
      - Include the total number of team members who submitted updates
      - Format using Markdown for readability

      Structure your summary with these sections:
      1. **Overview** — A one-sentence snapshot of the team's focus today
      2. **What the Team Did Yesterday** — Bullet points per person or grouped by theme
      3. **What the Team Is Working on Today** — Bullet points per person or grouped by theme
      4. **Blockers & Risks** — Only if any blockers exist; otherwise omit this section
      5. **Team Participation** — e.g. "5 of 6 team members submitted updates"
    PROMPT
  end

  def build_user_message
    date_str = @entries.first.entry_date.strftime("%A, %B %-d, %Y")
    lines = ["Standup entries for #{date_str}:\n"]

    @entries.each_with_index do |entry, i|
      lines << "---"
      lines << "**#{entry.user.name}**"
      lines << ""
      lines << "Yesterday: #{entry.yesterday}"
      lines << ""
      lines << "Today: #{entry.today}"
      if entry.blockers.present?
        lines << ""
        lines << "Blockers: #{entry.blockers}"
      end
      lines << ""
    end

    lines << "---"
    lines << "\nPlease generate a standup summary from the entries above."
    lines.join("\n")
  end

  def extract_text(response)
    text_block = response.content.find { |block| block.type == :text }
    raise "Claude returned no text content" unless text_block

    text_block.text.strip
  end
end
