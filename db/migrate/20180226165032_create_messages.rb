class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :content
      t.string :status
      t.string :destination
      t.string :phone_number
      t.references :colevent, foreign_key: true
      t.timestamps
    end
  end
end
