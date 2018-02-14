class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :type
      t.string :description
      t.string :link
      t.string :materials
      t.integer :user_id


  end
  end
end
