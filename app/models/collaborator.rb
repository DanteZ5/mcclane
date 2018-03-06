class Collaborator < ApplicationRecord
  require 'csv'
  belongs_to :user
  has_many :colevents

  validates :country, presence: true
  validates :email, presence: true
  validates :phone_pro, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :user_id, presence: true


  def self.import(file, current_user_id)
    csv_options = { col_sep: ';', headers: :first_row, header_converters: :symbol }
    CSV.foreach(file.path, csv_options) do |row|
      attributes = row.to_hash
      attributes["user_id"] = current_user_id
      Collaborator.create! attributes
    end
  end

  # reflechir a une methode de classe qui se substituerai au .all pour
  # recupererer uniquement les collaborators rattaches à un user
end
