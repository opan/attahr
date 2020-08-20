module Web
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

    def current_user
      if authenticated?
        warden.user
      else
        authenticate!
      end
    end
  end
end
