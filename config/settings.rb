# frozen_string_literal: true

module Biomrub
  class Settings < Hanami::Settings
    setting :session_secret, constructor: Types::String
    # Define your app settings here, for example:
    #
    # setting :my_flag, default: false, constructor: Types::Params::Bool
  end
end
