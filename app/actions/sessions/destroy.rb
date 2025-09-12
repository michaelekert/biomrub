# frozen_string_literal: true

module Biomrub
  module Actions
    module Sessions
      class Destroy < Biomrub::Action
        def handle(request, response)
          request.env["warden"].logout

          response.status = 200
          response.body = {}
        end

        private

        def verify_csrf_token?(_request, _response)
          false
        end
      end
    end
  end
end
