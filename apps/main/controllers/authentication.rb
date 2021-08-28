module Main
  module Authentication
    def self.included(action)
      action.class_eval do
        expose :current_user
      end
    end

    private

    def warden
      request.env['warden']
    end

    def authenticate!
      warden.authenticate!
    end

    def authenticated?
      warden.authenticated?
    end

    def logout
      authenticated? && warden.logout
    end

    def current_user
      warden.user
    end

    def superadmin_user?
      current_user.superadmin
    end
  end
end
