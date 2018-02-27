class Template < ApplicationRecord
  belongs_to :event

  validates :slot, presence: true
  validates :content, presence: true
  validates :order, presence: true

end
