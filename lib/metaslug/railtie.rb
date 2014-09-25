module Kaminari
  class Railtie < ::Rails::Railtie
    initializer 'metaslug' do |app|
      Metaslug::Hooks.init
    end
  end
end
