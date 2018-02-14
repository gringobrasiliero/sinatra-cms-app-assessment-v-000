class AddColumnUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :projects, :string
    remove_column :users, :attributes
  end
end
