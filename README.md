# Standup Bot

A Rails 7 app that collects daily standup updates from your team and uses **Claude** to synthesize them into a clean, readable summary. Optionally posts the summary to Slack.

## Features

- Simple form for team members to submit: *yesterday / today / blockers*
- Manager clicks **Generate Summary** → Claude synthesizes all entries
- Markdown-formatted summary with sections: Overview, Yesterday, Today, Blockers
- Optional Slack webhook posting
- Date navigation to view past standups
- No auth required (easy to add later)

## Stack

| Layer | Tech |
|---|---|
| Framework | Rails 7.1 |
| Database | SQLite3 |
| AI | Claude API (`claude-opus-4-6`) |
| Styling | Tailwind CSS (CDN) |
| HTTP client | Faraday (Slack webhook) |

## Models

```
Team ──< User ──< StandupEntry
Team ──< StandupSummary
```

- **Team** — groups users; optionally holds a Slack webhook URL
- **User** — team member
- **StandupEntry** — one per user per day (yesterday / today / blockers)
- **StandupSummary** — Claude-generated summary for a team+date

## Setup

### Prerequisites

- Ruby 3.1+
- Bundler

### 1. Install dependencies

```bash
cd standup-bot
bundle install
```

### 2. Configure environment

```bash
cp .env.example .env
# Edit .env — add your Anthropic API key (required) and Slack webhook (optional)
```

```
ANTHROPIC_API_KEY=sk-ant-...
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...  # optional
```

### 3. Set up database

```bash
bin/rails db:create db:migrate db:seed
```

Seeding creates the **Engineering** team with 5 sample users (Alice, Bob, Carol, Dave, Eve).

### 4. Start the server

```bash
bin/rails server
# Open http://localhost:3000
```

## Usage

1. **Submit standup** — team members go to `http://localhost:3000`, select their name, fill in the 3 fields, and hit Submit.
2. **Generate summary** — once entries are in, the manager clicks "✨ Generate Summary". Claude produces a structured Markdown summary.
3. **Post to Slack** — check "Also post to Slack" before generating, or click "📣 Post to Slack" on the summary page.
4. **View history** — click "Today's Entries" → navigate by date.

## Adding team members

```bash
bin/rails console
team = Team.first
team.users.create!(name: "Frank", email: "frank@example.com")
```

## Configuring Slack

Add a webhook URL to your team:

```bash
bin/rails console
Team.first.update!(slack_webhook_url: "https://hooks.slack.com/services/...")
```

Or set `SLACK_WEBHOOK_URL` in `.env` — the seed script picks it up automatically.

## Project structure

```
app/
  controllers/
    standup_entries_controller.rb   # form submit & list view
    standup_summaries_controller.rb # generate + show summary
  models/
    standup_entry.rb
    standup_summary.rb
    team.rb
    user.rb
  services/
    claude_summary_service.rb       # calls Claude API
    slack_notification_service.rb   # posts to Slack webhook
  views/
    standup_entries/new.html.erb    # main submission form
    standup_entries/index.html.erb  # list view with generate button
    standup_summaries/show.html.erb # rendered summary page
  helpers/
    application_helper.rb           # render_markdown helper
```

## Claude integration

`ClaudeSummaryService` uses `claude-opus-4-6` with adaptive thinking:

```ruby
response = @client.messages.create(
  model: "claude-opus-4-6",
  max_tokens: 2048,
  thinking: { type: "adaptive" },
  system: system_prompt,
  messages: [{ role: "user", content: formatted_entries }]
)
```

The system prompt instructs Claude to produce a structured summary with Overview, Yesterday, Today, Blockers, and Participation sections.

## Customization ideas

- Add simple cookie-based auth to pre-select the current user
- Email delivery via Action Mailer (send summary at 10am)
- Teams/workspace support for multiple teams
- Recurring schedule with Whenever/Sidekiq
- Upgrade to `tailwindcss-rails` for production assets
