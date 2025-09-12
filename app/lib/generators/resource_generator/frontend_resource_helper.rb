# frozen_string_literal: true

require "dry/inflector"

module ResourceGenerator
  module FrontendResourceHelper
    TYPE_MAPPINGS = {
      "string" => "string",
      "text" => "string",
      "integer" => "number",
      "float" => "number",
      "decimal" => "number",
      "boolean" => "boolean",
      "date" => "Date",
      "datetime" => "Date",
      "reference" => "number"
    }.freeze

    def inflector
      @inflector ||= Dry::Inflector.new
    end

    def frontend_columns_data
      columns.map do |col|
        name, raw_type = col.split(":")

        {
          name: name,
          type: TYPE_MAPPINGS[raw_type] || "string",
          raw_type: raw_type
        }
      end
    end

    def typescript_interface_fields
      frontend_columns_data.map do |col|
        if col[:raw_type] == "reference"
          "#{col[:name]}Id: number;"
        else
          "#{col[:name]}: #{col[:type]};"
        end
      end.join("\n  ")
    end

    def typescript_column_defs
      frontend_columns_data.map do |col|
        if col[:raw_type] == "reference"
          <<~TS.chomp
            {
              accessorKey: "#{col[:name]}Id",
              header: ({ column }) => (
                <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}>
                  #{col[:name].capitalize}
                  <ArrowUpDown className="ml-2 h-4 w-4" />
                </Button>
              ),
              cell: ({ row }) => (
                <EditableCell
                  row={row.original}
                  columnId="#{col[:name]}Id"
                  editingCell={editingCell}
                  setEditingCell={setEditingCell}
                  handleSave={handleSave}
                  type="select"
                  options={#{col[:name]}s.map((r) => ({ value: r.id, label: r.name ?? String(r.id) }))}
                  displayValue={#{col[:name]}NameById.get(row.original.#{col[:name]}Id) ?? row.original.#{col[:name]}Id}
                />
              ),
            }
          TS
        else
          <<~TS.chomp
            {
              accessorKey: "#{col[:name]}",
              header: ({ column }) => (
                <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}>
                  #{col[:name].capitalize}
                  <ArrowUpDown className="ml-2 h-4 w-4" />
                </Button>
              ),
              cell: ({ row }) => (
                <EditableCell
                  row={row.original}
                  columnId="#{col[:name]}"
                  editingCell={editingCell}
                  setEditingCell={setEditingCell}
                  handleSave={handleSave}
                  type="text"
                />
              ),
            }
          TS
        end
      end.join(",\n  ")
    end

    def typescript_column_labels
      frontend_columns_data.map do |col|
        if col[:raw_type] == "reference"
          %(#{col[:name]}Id: "#{col[:name].capitalize}")
        else
          %(#{col[:name]}: "#{col[:name].capitalize}")
        end
      end.join(",\n    ")
    end

    def zod_schema_fields
      frontend_columns_data.map do |col|
        case col[:raw_type]
        when "reference"
          %(#{col[:name]}Id: z.preprocess(val => Number(val), z.number()),)
        else
          case col[:type]
          when "string"
            %(#{col[:name]}: z.string().min(3, { message: "#{col[:name].capitalize} must be at least 3 characters." }),)
          when "number"
            %(#{col[:name]}: z.preprocess(val => Number(val), z.number()),)
          when "boolean"
            %(#{col[:name]}: z.boolean(),)
          when "Date"
            %(#{col[:name]}: z.date(),)
          else
            %(#{col[:name]}: z.any(),)
          end
        end
      end.join("\n  ")
    end

    def typescript_reference_imports
      frontend_columns_data
        .select { |col| col[:raw_type] == "reference" }
        .map do |col|
          related_plural = inflector.pluralize(col[:name].downcase)
          related_camel  = inflector.camelize(related_plural)
          "import #{related_camel}Api from \"@/api/#{related_plural}-api\";"
        end
        .join("\n")
    end
  end
end
