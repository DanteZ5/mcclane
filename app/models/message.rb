class Message < ApplicationRecord
  belongs_to :colevent
    # call method job to send sms

   validates :content, presence: true
   validates :phone_number, presence: true


  def send_sms
    message = self
    account_sid = ENV["account_sid"] # Your Account SID from www.twilio.com/console
    auth_token = ENV["auth_token"]   # Your Auth Token from www.twilio.com/console
    @client = Twilio::REST::Client.new account_sid, auth_token
    body = message.content
    to = message.phone_number
    @client.messages.create(
      body: body,
      to: to,
      from: "+33644603214")
  end

  # def scheduled_sms(timer)
  #   SmsJob.set(wait: timer.minutes).perform_later(self.id)
  # end

  # def delete_job

  # end


  # !!appliquer les regles des que possible
end



# FakeJob.set(wait: 1.minute).perform_later

# FakeJob.set(wait_until: Date.tomorrow.noon).perform_later
