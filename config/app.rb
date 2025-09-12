# frozen_string_literal: true

require "dotenv"
require "hanami"

Dotenv.load(".env", ".env.local")

require "debug" if %w[development test].include?(ENV["HANAMI_ENV"])
require "debug/open_nonstop" if ENV["HANAMI_ENV"] == "development"
require "bcrypt"
require "warden"

module Biomrub
  class App < Hanami::App
    config.middleware.use :body_parser, :json
    config.actions.sessions = :cookie, {
      key: "biomrub.session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365
    }
    config.middleware.use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = ->(env) { Biomrub::Actions::Sessions::AuthFailure.new.call(env) }
    end
  end
end
