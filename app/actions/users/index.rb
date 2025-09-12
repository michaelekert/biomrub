# frozen_string_literal: true

module Biomrub
  module Actions
    module Users
      class Index < Biomrub::Action
        include Deps["repos.user_repo"]

        def handle(_request, response)
          users = user_repo.all

          response.body = { records: users.map(&:to_h) }.to_json
        end
      end
    end
  end
end
