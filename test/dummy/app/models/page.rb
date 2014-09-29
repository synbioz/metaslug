class Page < ActiveRecord::Base
  liquid_methods :title, :description
end
