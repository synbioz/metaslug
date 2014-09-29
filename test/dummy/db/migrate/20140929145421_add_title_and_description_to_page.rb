class AddTitleAndDescriptionToPage < ActiveRecord::Migration
  def change
    add_column :pages, :title, :string
    add_column :pages, :description, :text
  end
end
