class AddColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :urlToImage, :string
  end
end