class ChangeColumnInProjects < ActiveRecord::Migration[5.1]
  def change
    rename_column :projects, :type, :type_of_p
  end
end
