# frozen_string_literal: true

Hanami.app.register_provider(:warden) do
  prepare do
    require "bcrypt"
    require "warden"
  end

  start do
    Warden::Strategies.add(:password) do
      def parsed_params
        @parsed_params ||= begin
          body = request.env["rack.input"].read
          request.env["rack.input"].rewind # Rewind so other middleware/controllers can still read it
          JSON.parse(body)
        rescue JSON::ParserError
          {}
        end
      end

      def valid?
        parsed_params["email"] && parsed_params["password"]
      end

      def authenticate!
        user = Biomrub::Repos::UserRepo.new.by_email(parsed_params["email"])

        if user && user.password_hash == BCrypt::Engine.hash_secret(parsed_params["password"], user.password_salt)

          return success!(user) # NOTE: user will be accessible under request.env["warden"].user in Hanami actions
        end

        fail!("Could not log in")
      end
    end

    Warden::Manager.serialize_into_session(&:id)
    Warden::Manager.serialize_from_session { |id| Biomrub::Repos::UserRepo.new.by_id(id) }
  end
end
