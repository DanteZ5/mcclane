class ChangeSafeToStringInColevents < ActiveRecord::Migration[5.1]
  def change
    change_column :colevents, :safe, :string
  end
end
