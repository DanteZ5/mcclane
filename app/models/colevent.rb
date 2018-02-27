class Colevent < ApplicationRecord
  belongs_to :collaborator
  belongs_to :event
  has_many :messages

end
