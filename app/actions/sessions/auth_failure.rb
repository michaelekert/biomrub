# frozen_string_literal: true

module Biomrub
  module Actions
    module Sessions
      class AuthFailure < Hanami::Action
        include Dry::Monads[:result]

        def handle(_request, response)
          response.body = { errors: { login: "Invalid email or password" } }.to_json
          response.status = 401
        end

        private

        def verify_csrf_token?(_req, _res)
          false
        end
      end
    end
  end
end
