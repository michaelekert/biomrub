# frozen_string_literal: true

module Biomrub
  module Repos
    class UserRepo < Biomrub::DB::Repo
      commands :create, update: :by_pk, delete: :by_pk

      def all
        users
          .select(:id, :full_name, :email)
          .order(users[:created_at].asc)
          .to_a
      end

      def by_email(email)
        users.where(email: email).one
      end

      def email_taken?(email)
        users.exist?(email: email)
      end

      def by_id(id)
        users.by_pk(id).one
      end

      def update(attributes)
        id = attributes.fetch(:id)
        record = attributes.fetch(:record).dup

        transaction do
          users.by_pk(id).command(:update).call(record)
        end

        by_id(id)
      end

      def email_taken_by_other?(email, id)
        users.where(email: email).exclude(id: id).exist?
      end
    end
  end
end
