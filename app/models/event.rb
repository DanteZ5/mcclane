class Event < ApplicationRecord
  before_save :default_values
  belongs_to :user
  has_many :templates
  has_many :messages, through: :colevents
  has_many :collaborators, through: :colevents

  validates :name, presence: true

  def default_values
    self.status ||= "ongoing"
  end
end
