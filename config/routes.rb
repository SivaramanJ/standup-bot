Rails.application.routes.draw do
  root "standup_entries#new"

  resources :standup_entries, only: [:new, :create, :index]
  resources :standup_summaries, only: [:show, :create]

  # Generate summary for a specific date (defaults to today)
  post "/standup_summaries/generate", to: "standup_summaries#generate", as: :generate_summary

  # Health check
  get "/up" => proc { [200, {}, ["OK"]] }
end
