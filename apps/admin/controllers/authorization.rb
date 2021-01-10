module Admin
  module Authorization
    def self.included(action)
      action.class_eval do
        before :superadmin?
      end
    end

    private
    
    def superadmin?
      unless current_user.superadmin
        flash[:errors] = ['You are not permitted to see this page']
        redirect_to Main.routes.root_path
      end
    end
  end
end
