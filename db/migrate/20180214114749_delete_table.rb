class DeleteTable < ActiveRecord::Migration[5.1]
  def up
     drop_table :attributes
   end

   def down
     raise ActiveRecord::IrreversibleMigration
   end
 end
