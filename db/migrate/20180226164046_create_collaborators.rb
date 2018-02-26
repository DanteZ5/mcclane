class CreateCollaborators < ActiveRecord::Migration[5.1]
  def change
    create_table :collaborators do |t|
      t.string :email
      t.string :phone_pro
      t.string :phone_perso
      t.string :first_name
      t.string :last_name
      t.string :continent
      t.string :country
      t.string :city
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
