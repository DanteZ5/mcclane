class Message < ApplicationRecord
  belongs_to :colevent
    # call method job to send sms

  def send_sms
    SmsJob.perform_later(self.id)
  end

  # !!appliquer les regles des que possible
end
