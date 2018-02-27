class Event < ApplicationRecord
  belongs_to :user
  has_many :templates
  has_many :messages, through: :colevents
  has_many :collaborators, through: :colevents

  validates :name, presence: true
  validates :status, presence: true
end
