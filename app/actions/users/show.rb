# frozen_string_literal: true

module Biomrub
  module Actions
    module Users
      class Show < Biomrub::Action
        include Deps["repos.user_repo"]

        params do
          required(:id).value(:integer)
        end

        def handle(request, response)
          user = user_repo.by_id(request.params[:id])

          if user
            response.status = 200
            response.body = { record: user.to_h }.to_json
          else
            response.status = 404
            response.body = { error: "User not found" }.to_json
          end
        end
      end
    end
  end
end
