# frozen_string_literal: true

module Biomrub
  module Contracts
    class DestroyContract < Dry::Validation::Contract
      params do
        required(:id).filled(:integer)
      end
    end
  end
end
