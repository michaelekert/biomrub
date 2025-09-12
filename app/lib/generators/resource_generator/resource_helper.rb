# frozen_string_literal: true

require "dry/inflector"

module ResourceGenerator
  module ResourceHelper
    def inflector
      @inflector ||= Dry::Inflector.new
    end

    def namespace
      @namespace ||= if File.exist?(".project_namespace")
                       File.read(".project_namespace").strip
                     else
                       "DefaultNamespace"
                     end
    end

    def plural
      @plural ||= resource_name.downcase
    end

    def singular
      @singular ||= inflector.singularize(plural)
    end

    def camel
      @camel ||= inflector.camelize(singular)
    end

    def camel_plural
      @camel_plural ||= inflector.camelize(plural)
    end

    def repo
      @repo ||= "#{singular}_repo"
    end

    def indent(text, spaces = 2)
      str = text.is_a?(Array) ? text.join("\n") : text.to_s
      str.lines.map { |line| (" " * spaces) + line }.join
    end

    def contract_fields
      body = columns_data.reject { |c| c[:name] == "id" }.map do |c|
        if c[:type] == "reference"
          "required(:#{c[:name]}_id).filled(:integer, gt?: 0)"
        else
          "required(:#{c[:name]}).filled(:#{c[:type]})"
        end
      end.join("\n")

      indent(body, 13)
    end

    def contract_deps
      deps = ["#{singular}_repo"]
      columns_data.select { |c| c[:type] == "reference" }.each do |c|
        deps << "#{c[:name]}_repo"
      end
      deps.map { |d| "include Deps[\"repos.#{d}\"]" }.join("\n        ")
    end
  end
end
