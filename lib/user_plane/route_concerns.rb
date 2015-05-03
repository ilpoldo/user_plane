module UserPlane
  module RouteConcerns

    DEFAULTS = {module: 'user_plane', shallow_prefix: true, on: :collection}

    class AbstractConcern
      def initialize(defaults = nil)
        @defaults = defaults || RouteConcerns::DEFAULTS
      end

      # The abstract concern should be able to handle resources having a preferred
      # collection/resource target.
      def call(mapper, options = {})
        resource_scope = mapper.send :resource_scope?
        if resource_scope
          options_factory = lambda { |o| @defaults.merge(options).merge(o) }
        else
          options_factory = lambda { |o| @defaults.merge(options).merge(o).except(:on) }
        end
        build(mapper, options_factory)
      end
    end


    class Base < AbstractConcern
      def build(mapper, options)
        mapper.resource :session, options.call(only: [:new, :create, :destroy])
        mapper.resource :details, options.call(only: [:edit, :update],
                                               as: :update_details,
                                               on: :member,
                                               constraints: SignedInConstraint.new())
      end
    end

    class SignUp < AbstractConcern
      def build(mapper, options)
        mapper.resource :sign_up, options.call(only: [:new, :create])
      end
    end

    # An alternative to the SignUp concern it provides routes to handle sign up invites
    class Invites < AbstractConcern
      def build(mapper, options)
        mapper.resources :sign_up, options.call(only: [:edit, :update],
                                                as: :sign_up_with_invite,
                                                param: :code)

        #TODO: Add a logged in constraint
        mapper.resources :invite, options.call(only: [:new, :create],
                                               as: :send_sign_up_invites,
                                               constraints: SignedInConstraint.new())

      end
    end

    # Provides extra routes to manage email identities: password resets and email
    # confirmations
    class EmailIdentity < AbstractConcern
      def build(mapper, options)
        mapper.scope controller: :reset_passwords do
          mapper.resources :reset_passwords, options.call(only: [:new, :create],
                                                          param: :code,
                                                          as: :send_password_resets)

          mapper.resources :reset_passwords, options.call(only: [:edit, :update],
                                                          param: :code)
        end

        mapper.get '/confirm_emails/:code', options.call(to: 'confirm_email_addresses#update',
                                                         as: :confirm_email_address)
      end
    end

  end
end
