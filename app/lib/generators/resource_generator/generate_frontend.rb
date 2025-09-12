# frozen_string_literal: true

require "thor"
require "thor/group"
require_relative "resource_helper"
require_relative "frontend_resource_helper"

module ResourceGenerator
  class GenerateFrontend < Thor::Group
    include Thor::Actions
    include ResourceHelper
    include FrontendResourceHelper

    argument :resource_name
    argument :columns, type: :array, default: []

    def self.source_root
      File.expand_path("templates/frontend", __dir__)
    end

    def create_api
      template("resource-api.ts.tt", "frontend/src/api/#{resource_name}-api.ts")
    end

    def create_resource_table
      template("ResourceTable.tsx.tt", "frontend/src/components/#{camel_plural}Table.tsx")
    end

    def create_resource_list_page
      template("ResourceListPage.tsx.tt", "frontend/src/pages/#{camel_plural}ListPage.tsx")
    end

    def update_vite_proxy
      line = %("/#{plural}": "http://localhost:2300",\n)
      insert_into_file(
        "frontend/vite.config.ts",
        indent(line, 6),
        after: /proxy:\s*\{\n/
      )
    end

    def add_index_app_routes
      line = %(<Route path="/list_#{plural}" element={<#{camel_plural}ListPage />} />\n)
      insert_into_file(
        "frontend/src/App.tsx",
        indent(line, 8),
        after: /<Routes>\n/
      )
    end

    def add_update_app_routes
      line = %(<Route path="/update_#{singular}/:id" element={<#{camel}UpdatePage />} />\n)
      insert_into_file(
        "frontend/src/App.tsx",
        indent(line, 8),
        after: /<Routes>\n/
      )
    end

    def add_index_to_app_imports
      import_line = "import #{camel_plural}ListPage from \"@/pages/#{camel_plural}ListPage\";\n"
      insert_into_file(
        "frontend/src/App.tsx",
        indent(import_line, 0),
        after: "// GENERATOR_IMPORT_ANCHOR\n"
      )
    end

    def add_update_to_app_imports
      import_line = "import #{camel}UpdatePage from \"@/pages/#{camel}UpdatePage\";\n"
      insert_into_file(
        "frontend/src/App.tsx",
        indent(import_line, 0),
        after: "// GENERATOR_IMPORT_ANCHOR\n"
      )
    end

    def update_app_routes_new
      line = %(<Route path="/new_#{singular}" element={<#{camel}NewPage />} />\n)
      insert_into_file(
        "frontend/src/App.tsx",
        indent(line, 8),
        after: /<Routes>\n/
      )
    end

    def update_app_imports_new
      import_line = "import #{camel}NewPage from \"@/pages/#{camel}NewPage\";\n"
      insert_into_file(
        "frontend/src/App.tsx",
        indent(import_line, 0),
        after: "// GENERATOR_IMPORT_ANCHOR\n"
      )
    end

    def update_app_sidebar
      content = <<~TSX.chomp
        {
          title: "#{camel_plural}",
          url: "#",
          icon: SquareTerminal,
          isActive: true,
          items: [
            {
              title: "List",
              url: "/list_#{plural}",
            },
          ],
        },
      TSX

      insert_into_file(
        "frontend/src/components/AppSidebar.tsx",
        indent(content, 4),
        after: "// GENERATOR-ANCHOR\n"
      )
    end

    def create_resource_update_page
      template("ResourceUpdatePage.tsx.tt", "frontend/src/pages/#{camel}UpdatePage.tsx")
    end

    def create_resource_update_form
      template("ResourceUpdateForm.tsx.tt", "frontend/src/components/#{camel}UpdateForm.tsx")
    end

    def create_resource_form
      template("ResourceForm.tsx.tt", "frontend/src/components/#{camel}Form.tsx")
    end

    def create_resource_new_page
      template("ResourceNewPage.tsx.tt", "frontend/src/pages/#{camel}NewPage.tsx")
    end
  end
end
