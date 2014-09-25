class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.string :title
      t.boolean :active
      t.references :category, index: true

      t.timestamps
    end
  end
end
