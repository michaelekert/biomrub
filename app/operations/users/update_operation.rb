# frozen_string_literal: true

module Biomrub
  module Operations
    module Users
      class UpdateOperation < Biomrub::Operation
        include Deps[
          "repos.user_repo",
          "contracts.users.update_contract"
        ]

        def call(params)
          sanitized_params = step validate(params)
          step find_record(sanitized_params[:id])
          step update_record(sanitized_params)
        end

        private

        def validate(params)
          contract_result = update_contract.call(params)

          if contract_result.success?
            Success(contract_result.to_h)
          else
            Failure[:validation_error,
                    contract_result.errors.to_h]
          end
        end

        def find_record(id)
          record = user_repo.by_id(id)
          record ? Success() : Failure(:not_found)
        end

        def update_record(attributes)
          updated_record = user_repo.update(attributes)
          Success(updated_record)
        end
      end
    end
  end
end
