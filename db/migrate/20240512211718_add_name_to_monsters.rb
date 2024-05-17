class AddNameToMonsters < ActiveRecord::Migration[7.0]
  def change
    add_column :monsters, :name, :string, null: false
  end
end
