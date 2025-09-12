# frozen_string_literal: true

module Biomrub
  module Contracts
    module Users
      class UpdateContract < Dry::Validation::Contract
        include Deps["repos.user_repo"]

        params do
          required(:id).filled(:integer)
          required(:record).hash do
            required(:email).filled(:string)
            required(:full_name).filled(:string)
          end
        end

        rule(record: :email) do
          key.failure("Email already taken") if user_repo.email_taken_by_other?(value, values[:id])
        end
      end
    end
  end
end
