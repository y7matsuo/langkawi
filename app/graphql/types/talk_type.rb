module Types
  class TalkType < Types::BaseObject
    field :message, String
    field :submitter, Types::SubmitterCategory
    field :status, Types::EnabledCategory
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
