# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module Biomrub
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]

    before do |request, response|
      authenticate_user(request, response)
    end

    format :json

    private

    def current_user(request)
      request.env["warden"].user
    end

    def skip_authenticate_user?
      false
    end

    def authenticate_user(request, _response)
      return if skip_authenticate_user?
      return if current_user(request)

      halt 401, { errors: { login: "Unauthorized" } }.to_json
    end

    # HACK: overridden Hanami methods to work with symbolized params.
    # TODO: investigate if it could be handled in some sane way or it's just Hanami bug
    def missing_csrf_token?(req, *)
      Hanami::Utils::Blank.blank?(req.params.raw[CSRF_TOKEN])
    end

    def invalid_csrf_token?(req, res)
      return false unless verify_csrf_token?(req, res)

      missing_csrf_token?(req, res) ||
        !::Rack::Utils.secure_compare(req.session[CSRF_TOKEN], req.params.raw[CSRF_TOKEN])
    end
  end
end
