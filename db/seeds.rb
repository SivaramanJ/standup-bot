# Seeds for local development
# Run with: rails db:seed

team = Team.find_or_create_by!(slug: "engineering") do |t|
  t.name = "Engineering"
  t.slack_webhook_url = ENV["SLACK_WEBHOOK_URL"]
end

puts "Team: #{team.name}"

%w[Alice Bob Carol Dave Eve].each do |name|
  email = "#{name.downcase}@example.com"
  user = team.users.find_or_create_by!(email: email) { |u| u.name = name }
  puts "  User: #{user.name}"
end

puts "\nDone! Seed data created."
puts "Run the app with: bin/rails server"
