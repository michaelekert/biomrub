# frozen_string_literal: true

module Biomrub
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.

    post "/sessions", to: "sessions.create"
    delete "/sessions", to: "sessions.destroy"
    get "/sessions/csrf_token", to: "sessions.csrf_token"

    get "/users", to: "users.index"
    get "/users/:id", to: "users.show"
    patch "/users/:id", to: "users.update"
  end
end
