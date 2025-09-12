# frozen_string_literal: true

module Biomrub
  module Actions
    module Users
      class Update < Biomrub::Action
        include Deps["operations.users.update_operation"]

        def handle(request, response)
          case update_operation.call(request.params.to_h)
          in Success(record)
            response.status = 200
            response.body = { record: record }.to_json
          in Failure[:validation_error, errors]
            response.status = 422
            response.body = { errors: errors }.to_json
          in Failure(:not_found)
            response.status = 404
            response.body = { errors: "User not found" }.to_json
          end
        end
      end
    end
  end
end
