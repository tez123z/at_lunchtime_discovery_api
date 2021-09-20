class CreateTableDenyList < ActiveRecord::Migration[6.1]
  def change
    create_table :deny_list do |t|
      t.string :jti, null: false 
    end
    add_index :deny_list, :jti
  end
end
