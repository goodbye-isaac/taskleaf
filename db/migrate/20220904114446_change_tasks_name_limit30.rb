class ChangeTasksNameLimit30 < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :name, :string, :limit => 30 #By default SQL String limit 255 character 
  end
  
  def down 
    change_column :tasks, :name< :string
  end
end
