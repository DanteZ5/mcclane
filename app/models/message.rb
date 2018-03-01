class Message < ApplicationRecord
  belongs_to :colevent
    # call method job to send sms

   validates :content, presence: true
   validates :phone_number, presence: true


  def send_sms
    SmsJob.perform_later(self.id)
  end

  # !!appliquer les regles des que possible
end
