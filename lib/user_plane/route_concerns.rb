module UserPlane
  module RouteConcerns

    DEFAULTS = {namespace: 'user', on: :collection}

    class AbstractConcern
      def initialize(defaults = nil)
        defaults ||= RouteConcerns::DEFAULTS
        @namespace = defaults[:namespace]
        @defaults = defaults.except(:namespace)
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

        mapper.namespace @namespace, path: '/' do
          build(mapper, options_factory)
        end
      end
    end

    # Defines two resources:
    # A session resource to sign a user in and out
    # A details resource to let a user change the account's details
    # It also defines an extra concern
    # And a signed_in routing concern to ensure that child routes are accessible only
    # to signed in users.
    # It defines a route to edit the account details and one to sign in and sign out.
    #
    # To enforce being singed in to certain resources:
    # resource :score, concern: :signed_in
    #
    # scope '/profile' concern: :signed_in do
    #   resource :score
    #   resource :buddies
    # end
    #
    class Base < AbstractConcern

      def default_sign_in_constraint
        -> (r) {Session.new(r.session).signed_in?}
      end

      def initialize(defaults = nil)
        @signed_in_constraint = Hash(defaults).delete(:sign_in_constraint) {|k| default_sign_in_constraint}
        super defaults
      end

      def singed_in_constraint
        @sign_in_constraint.constantize
      end

      def build(mapper, options)
        mapper.concern :signed_in do
          scope constraint: sign_in_constraint.new() {yield}
        end

        mapper.resource :session, options.call(only: [:new, :create, :destroy])

        mapper.resource :details, options.call(only: [:edit, :update],
                                               as: :update_details,
                                               on: :member,
                                               concern: :signed_in)
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
        mapper.resources :sign_ups, options.call(only: [:edit, :update],
                                                 as: :sign_up_with_invites,
                                                 controller: :sign_up_with_invites,
                                                 param: :code,
                                                 path_names: {edit: 'redeem'})
        mapper.resources :invites, options.call(only: [:new, :create],
                                                as: :send_sign_up_invites,
                                                concern: :signed_in)
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

        mapper.get '/confirm_email/:code', options.call(to: 'confirm_email_addresses#update',
                                                        as: :confirm_email_address)
      end
    end

  end
end
