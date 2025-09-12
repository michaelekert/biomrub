# frozen_string_literal: true

require "thor"
require_relative "generate_backend"
require_relative "generate_frontend"

module ResourceGenerator
  class CLI < Thor
    desc "generate RESOURCE_NAME [COLUMNS:TYPE]", "Generates resource files"
    def generate(*args)
      say "Generating backend..."
      GenerateBackend.start(args)
      say "Generating frontend..."
      GenerateFrontend.start(args)
    end

    desc "destroy RESOURCE_NAME", "Destroys generated resource files"
    def destroy(*args)
      say "Reverting backend..."
      GenerateBackend.start(args, behavior: :revoke)
      say "Reverting frontend..."
      GenerateFrontend.start(args, behavior: :revoke)
    end
  end
end
