class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :published, :publishedAt
    rename_column :posts, :content, :description

  end
end
