module UserPlane
  module RouteConcerns

    DEFAULTS = {module: 'user_plane'}

    class SignUp
      def initialize(defaults = nil)
        @defaults = defaults || RouteConcerns::DEFAULTS
      end

      def call(mapper, options = {})
        options = @defaults.merge(options)
        mapper.resource :sign_up, options.merge(only: [:new, :create])
      end
    end

    class Invites
      def initialize(defaults = nil)
        @defaults = defaults || RouteConcerns::DEFAULTS
      end

      def call(mapper, options = {})
        options = @defaults.merge(options)
        mapper.resource :sign_up, options.merge(only: [:new, :create])

        #TODO: Add a logged in constraint
        mapper.resources :invite, options.merge(only: [:new, :create],
                                                as: :send_sign_up_invites)

      end
    end

    class EmailIdentity
      def initialize(defaults = nil)
        @defaults = defaults || RouteConcerns::DEFAULTS
      end

      def call(mapper, options = {})
        options = @defaults.merge(options)
        mapper.resource :session, options.merge(only: [:new, :create, :destroy])

        mapper.scope controller: :reset_passwords do
          mapper.resources :reset_passwords, options.merge(only: [:new, :create],
                                                           param: :code,
                                                           as: :send_password_resets)

          mapper.resources :reset_passwords, options.merge(only: [:edit, :update],
                                                           param: :code)
        end

        mapper.resources :confirm_emails, options.merge(only: [:show],
                                                        param: :code,
                                                        as: :confirm_email_address)
      end
    end

  end
end
