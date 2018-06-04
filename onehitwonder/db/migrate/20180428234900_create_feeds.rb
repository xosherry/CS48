class CreateFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
