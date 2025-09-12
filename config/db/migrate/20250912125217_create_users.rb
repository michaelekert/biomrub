# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :users do
      primary_key :id
      column :email, :text, null: false
      column :full_name, :text, null: false
      column :password_hash, :text, null: false
      column :password_salt, :text, null: false

      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP

      index :email, unique: true
      index :full_name
    end
  end
end
