# Written March 2015
# Was originally http://reddit.com/u/whispen, but got shadow banned for spam
# Now at http://reddit.com/u/whispen2, but reddit blocked all of the IP addresses that Heroku uses so it no longer posts.
# View a blog post about it at: http://jenniferkruse.me/post20150302.html

require 'bundler/setup'
require 'cleverbot-api'
require 'redd'

# Authenticate using the bot's reddit account username and password.
r = Redd::Client::Authenticated.new_from_credentials "Username", "Password", user_agent: ""

bot = CleverBot.new

begin
5.times do
  # recent comments from everyone
  r.comment_stream "all" do |comment|
    answer = bot.think comment.body

    # Wait before posting so it's less obvious that this is a bot.
    sleepTime = rand(150)

    # Sometimes Cleverbot returns a response saying that it is cleverbot or something..
    sleep(sleepTime) unless (answer.include?('clever')
    comment.reply answer unless (answer.include?('clever')

    # Give it another chance to loop through if it was talking about cleverbot
    break unless (answer.include?('clever')
  end
end
rescue Redd::Error::RateLimited => e
  puts "rate limited :( #{e.time} left"
  time_left = e.time
  sleep(time_left)
rescue Redd::Error => e
  puts "Error happened"
  status = e.code
  # 5-something errors are usually errors on reddit's end.
  raise e unless (500...600).include?(status)
end
