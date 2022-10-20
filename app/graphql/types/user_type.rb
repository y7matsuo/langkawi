module Types
  class UserType < Types::BaseObject
    field :id, Int
    field :user_type, Types::UserCategory
    field :first_name, String
    field :last_name, String
    field :gender, Types::GenderCategory
    field :age, Int
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :detail, Types::UserDetailType

    def detail
      UserDetail.find_by(user_id: object.id)
    end
  end
end
