# frozen_string_literal: true

require "thor"
require "thor/group"
require_relative "resource_helper"

module ResourceGenerator
  class GenerateBackend < Thor::Group
    include Thor::Actions
    include ResourceHelper

    VALID_COLUMN_TYPES = %w[string integer float bool date date_time array hash reference].freeze

    def self.exit_on_failure?
      true
    end

    argument :resource_name
    argument :columns, type: :array, default: []

    def self.source_root
      File.expand_path("templates/backend", __dir__)
    end

    def validate_columns
      columns_data
    end

    def create_relation
      template("relation.tt", "app/relations/#{plural}.rb")
    end

    def create_repo
      template("repo.tt", "app/repos/#{repo}.rb")
    end

    def create_actions
      dir = "app/actions/#{plural}"

      empty_directory dir
      template("actions/index.tt", "#{dir}/index.rb")
      template("actions/show.tt", "#{dir}/show.rb")
      template("actions/create.tt", "#{dir}/create.rb")
      template("actions/update.tt", "#{dir}/update.rb")
      template("actions/delete.tt", "#{dir}/delete.rb")
    end

    def create_migration
      template("migration.tt", "config/db/migrate/#{migration_filename}")
    end

    def create_requests_tests
      dir = "spec/requests/#{plural}"

      empty_directory dir
      template("spec/requests/index_spec.tt", "#{dir}/index_spec.rb")
      template("spec/requests/show_spec.tt", "#{dir}/show_spec.rb")
      template("spec/requests/create_spec.tt", "#{dir}/create_spec.rb")
      template("spec/requests/delete_spec.tt", "#{dir}/delete_spec.rb")
      template("spec/requests/update_spec.tt", "#{dir}/update_spec.rb")
    end

    def create_operations_tests
      dir = "spec/operations/#{plural}"

      empty_directory dir
      template("spec/operations/create_operation_spec.tt", "#{dir}/create_operation_spec.rb")
      template("spec/operations/update_operation_spec.tt", "#{dir}/update_operation_spec.rb")
      template("spec/operations/delete_operation_spec.tt", "#{dir}/delete_operation_spec.rb")
    end

    def create_contracts_tests
      dir = "spec/contracts/#{plural}"

      empty_directory dir
      template("spec/contracts/create_contract_spec.tt", "#{dir}/create_contract_spec.rb")
      template("spec/contracts/update_contract_spec.tt", "#{dir}/update_contract_spec.rb")
    end

    def add_route
      routes = <<~RUBY
        get "/#{plural}", to: "#{plural}.index"
        get "/#{plural}/:id", to: "#{plural}.show"
        post "/#{plural}", to: "#{plural}.create"
        patch "/#{plural}/:id", to: "#{plural}.update"
        delete "/#{plural}/:id", to: "#{plural}.delete"
      RUBY

      insert_into_file "config/routes.rb", indent(routes, 4), before: /^  end$/
    end

    def create_contracts
      dir = "app/contracts/#{plural}"

      empty_directory dir
      template("contracts/create_contract.tt", "#{dir}/create_contract.rb")
      template("contracts/update_contract.tt", "#{dir}/update_contract.rb")
    end

    def create_operations
      dir = "app/operations/#{plural}"

      empty_directory dir
      template("operations/create_operation.tt", "#{dir}/create_operation.rb")
      template("operations/update_operation.tt", "#{dir}/update_operation.rb")
      template("operations/delete_operation.tt", "#{dir}/delete_operation.rb")
    end

    private

    def columns_data
      parsed_columns = columns.map do |col|
        name, type = col.split(":")
        type ||= "string"
        { name: name, type: type }
      end

      unknown_types = parsed_columns.reject { |c| VALID_COLUMN_TYPES.include?(c[:type]) }

      if unknown_types.any?
        message = unknown_types.map do |col|
          "Unknown column type: '#{col[:type]}' for field '#{col[:name]}'"
        end.join("\n")
        message += "\nAllowed types are: #{VALID_COLUMN_TYPES.join(', ')}"
        raise Thor::Error, message
      end

      parsed_columns
    end

    def columns_list
      (["id"] + columns_data.map { |c| c[:type] == "reference" ? "#{c[:name]}_id" : c[:name] }).uniq
    end

    def columns_code
      columns_data
        .reject { |c| c[:name] == "id" }
        .map do |c|
          case c[:type]
          when "reference"
            table = inflector.pluralize(c[:name])
            "foreign_key :#{c[:name]}_id, :#{table}, null: false"
          when "string"
            "column :#{c[:name]}, :text"
          else
            "column :#{c[:name]}, :#{c[:type]}"
          end
        end.join("\n")
    end

    def migration_filename
      find_existing_migration || generate_migration_name
    end

    def find_existing_migration
      Dir.glob("config/db/migrate/*_create_#{plural}.rb").first&.split("/")&.last
    end

    def generate_migration_name
      "#{Time.now.strftime('%Y%m%d%H%M%S')}_create_#{plural}.rb"
    end
  end
end
