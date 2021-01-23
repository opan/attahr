module Admin
  module Authorization
    def self.included(action)
      action.class_eval do
        # before :superadmin?
      end
    end

    private

    def superadmin?
      unless current_user.superadmin
        flash[:errors] = ['You are not permitted to see this page']
        # This should be Main.routes.root_path
        # Need to find out how to load Main apps routes
        redirect_to Admin.routes.sign_in_path
      end
    end
  end
end
