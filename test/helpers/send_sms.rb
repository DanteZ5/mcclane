require 'rubygems'
require 'twilio-ruby'
require 'pry'

account_sid = ENV["account_sid"] # Your Account SID from www.twilio.com/console
auth_token = ENV["auth_token"]   # Your Auth Token from www.twilio.com/console

@client = Twilio::REST::Client.new account_sid, auth_token

message = @client.messages.create(
    body: "Hello from McClane",
    to: "+33634264547",    # Replace with your phone number
    from: "+33644603214")  # Replace with your Twilio number

puts message.sid
