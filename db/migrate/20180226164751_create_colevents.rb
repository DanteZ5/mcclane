class CreateColevents < ActiveRecord::Migration[5.1]
  def change
    create_table :colevents do |t|
      t.boolean :safe
      t.string :safe_time
      t.references :collaborator, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
