class Colevent < ApplicationRecord
  before_save :default_values
  belongs_to :collaborator
  belongs_to :event

  validates :safe, presence :true
end

def default_values
    self.safe ||= false
  end
