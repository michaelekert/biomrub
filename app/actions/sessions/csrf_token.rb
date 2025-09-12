# frozen_string_literal: true

module Biomrub
  module Actions
    module Sessions
      class CSRFToken < Biomrub::Action
        def handle(_request, response)
          response.body = { csrf_token: response.session[:_csrf_token] }.to_json
        end

        def skip_authenticate_user?
          true
        end
      end
    end
  end
end
