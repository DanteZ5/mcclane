class Message < ApplicationRecord
  belongs_to :colevent
    # call method job to send sms

   validates :content, presence: true
   validates :phone_number, presence: true


  # def send_sms
  #   SmsJob.perform_later(self.id)
  # end

  # def scheduled_sms(timer)
  #   SmsJob.set(wait: timer.minutes).perform_later(self.id)
  # end

  # def delete_job

  # end


  # !!appliquer les regles des que possible
end



# FakeJob.set(wait: 1.minute).perform_later

# FakeJob.set(wait_until: Date.tomorrow.noon).perform_later
