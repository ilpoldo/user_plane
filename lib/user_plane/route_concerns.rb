module UserPlane
  module RouteConcerns

    DEFAULTS = {namespace: 'user', on: :collection}

    class AbstractConcern
      attr_accessor :concern_options
      attr_accessor :mapper

      def initialize(defaults = nil)
        defaults ||= RouteConcerns::DEFAULTS
        @namespace = defaults[:namespace]
        @defaults = defaults.except(:namespace)
      end

      # Returns true if a particular concern exists
      def exists? concern 
        mapper.instance_variable_get('@concerns').include?(concern)
      end

      # The abstract concern should be able to handle resources having a preferred
      # collection/resource target.
      def call(mapper, concern_options = {})
        @mapper = mapper
        @concern_options = concern_options

        build
      end

      def options custom_route_options={}
        resource_scope = mapper.send :resource_scope?

        if resource_scope
          @defaults.merge(@concern_options).merge(custom_route_options)
        else
          @defaults.merge(@concern_options).merge(custom_route_options).except(:on)
        end
      end
    end

    class AbstractNamespacedConcern < AbstractConcern
      # The abstract concern should be able to handle resources having a preferred
      # collection/resource target.
      def call(mapper, concern_options = {})
        @mapper = mapper
        @concern_options = concern_options

        mapper.namespace @namespace, path: '/' do
          build
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
    class Base < AbstractNamespacedConcern

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

      def build
        mapper.concern :signed_in do
          scope constraint: sign_in_constraint.new() {yield}
        end

        mapper.resource :session, options(only: [:new, :create, :destroy]) do
          if exists? :auth_callback
            mapper.concerns :auth_callback, controller: :sessions
          end
        end

        mapper.resource :details, options(only: [:edit, :update],
                                          as: :update_details,
                                          on: :member,
                                          concern: :signed_in)
      end
    end

    class SignUp < AbstractNamespacedConcern
      def build
        mapper.resource :sign_up, options(only: [:new, :create]) do
          if exists? :auth_callback
            mapper.concerns :auth_callback, controller: :sign_up
          end
        end
      end
    end

    # An alternative to the SignUp concern that provides routes to handle sign
    # up via invites.
    class Invites < AbstractNamespacedConcern
      def build
        sign_up_options = options(only: [:edit, :update],
                                  path_names: {edit: 'redeem'},
                                  as: :sign_up_with_invites,
                                  param: :code)
        
        mapper.resources :invites,  sign_up_options do
          if exists? :auth_callback
            mapper.concerns :auth_callback, controller: :invites
          end
        end
        
        mapper.resources :invites, options(only: [:new, :create],
                                           as: :send_sign_up_invites,
                                           concern: :signed_in)
      end
    end

    # Provides extra routes to manage email identities: password resets and email
    # confirmations
    class EmailIdentity < AbstractNamespacedConcern
      def build
        mapper.scope controller: :reset_passwords do
          mapper.resources :reset_passwords, options(only: [:new, :create],
                                                     param: :code,
                                                     as: :send_password_resets)

          mapper.resources :reset_passwords, options(only: [:edit, :update],
                                                     param: :code)
        end

        mapper.get '/confirm_email/:code', options(to: 'confirm_email_addresses#update',
                                                   as: :confirm_email_address)
      end
    end

    class OAuthCallback < AbstractConcern

      def build
        controller = concern_options.delete(:controller) || 'sessions'

        mapper.resources :auth, options(as: :o_auth_callback,
                                        only: :edit,
                                        path_names: {edit: 'callback'},
                                        param: :provider,
                                        on: :member,
                                        to: "#{controller}#oauth_callback")
      end
    end

  end
end
