class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :question_content
      t.string :status
      t.string :answer_content
      t.string :answer_time
      t.string :phone_number
      t.references :colevent, foreign_key: true

      t.timestamps
    end
  end
end
