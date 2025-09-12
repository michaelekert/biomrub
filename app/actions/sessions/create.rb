# frozen_string_literal: true

module Biomrub
  module Actions
    module Sessions
      class Create < Biomrub::Action
        def handle(request, response)
          request.env["warden"].authenticate!(:password)

          response.status = 200
          response.body = {}
        end

        private

        def skip_authenticate_user?
          true
        end

        def verify_csrf_token?(_request, _response)
          false
        end
      end
    end
  end
end
