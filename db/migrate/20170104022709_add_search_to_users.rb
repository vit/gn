class AddSearchToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :search, :string
  end
end
