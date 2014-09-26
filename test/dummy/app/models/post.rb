class Post < ActiveRecord::Base
  liquid_methods :title

  belongs_to :category
end
