class CreateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :templates do |t|
      t.integer :slot
      t.string :content
      t.integer :order
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
