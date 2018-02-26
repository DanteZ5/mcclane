class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :status
      t.string :end_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
