module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField
    include RelationService

    field_class Types::BaseAdminField

    field :accounts, Types::AccountType.connection_type

    def accounts
      Account.all
    end

    field_class Types::BaseAuthField

    field :users, Types::UserType.connection_type

    field :user, Types::UserType do
      argument :user_id, Int
    end

    field :relations, Types::RelationType.connection_type do
      argument :position_status, Types::RelationPositionCategory
    end

    field :relation, Types::RelationType do
      argument :counter_user_id, Int
    end

    def users
      User.all
    end

    def user(user_id:)
      User.find(user_id)
    end

    def relations(position_status:)
      validate_position_status(position_status)
      user_item_condition(context[:user]&.id, position_status).order(updated_at: :desc).all
    end

    def relation(counter_user_id:)
      find_relation(context[:user]&.id, counter_user_id)
    end
  end
end
