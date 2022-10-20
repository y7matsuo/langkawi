module Types
  class AccountType < Types::BaseObject
    field :id, Int
    field :account_type, Types::AccountCategory
    field :email, String
    field :password, String
    field :status, Types::ActiveCategory
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user, Types::UserType

    def user
      User.find_by(account_id: object.id)
    end
  end
end
