module Metaslug
  class Hooks
    def self.init
      ActiveSupport.on_load(:action_controller) do
        require 'metaslug/controllers/action_controller_extension'
        ::ActionController::Base.send :include, Metaslug::ActionControllerExtension
      end

      ActiveSupport.on_load(:action_view) do
        require 'metaslug/helpers/action_view_extension'
        ::ActionView::Base.send :include, Metaslug::ActionViewExtension
      end
    end
  end
end
