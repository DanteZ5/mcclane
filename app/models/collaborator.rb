class Collaborator < ApplicationRecord
  belongs_to :user
  has_many :colevents

  validates :country, presence: true
  validates :email, presence: true
  validates :phone_pro, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :user_id, presence: true

  # reflechir a une methode de classe qui se substituerai au .all pour
  # recupererer uniquement les collaborators rattaches à un user
end
