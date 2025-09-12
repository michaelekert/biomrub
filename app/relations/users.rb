# frozen_string_literal: true

module Biomrub
  module Relations
    class Users < Biomrub::DB::Relation
      schema :users, infer: true
    end
  end
end
