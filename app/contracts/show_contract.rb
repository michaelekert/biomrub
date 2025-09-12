# frozen_string_literal: true

module Biomrub
  module Contracts
    class ShowContract < Dry::Validation::Contract
      params do
        required(:id).filled(:integer)
      end
    end
  end
end
