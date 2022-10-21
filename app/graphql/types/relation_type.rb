module Types
  class RelationType < Types::BaseObject
    include RelationService

    field :id, Int
    field :user, Types::UserType
    field :position_status, Types::RelationPositionCategory
    field :next_statuses, [Types::RelationCategory]
    field :action_a_date, GraphQL::Types::ISO8601DateTime, null: true
    field :action_b_date, GraphQL::Types::ISO8601DateTime, null: true
    field :action_c_date, GraphQL::Types::ISO8601DateTime, null: true
    
    def user
      resolve_relation_user(context[:user]&.id, object)
    end

    def position_status
      resolve_relation_position_status(context[:user]&.id, object)
    end

    def next_statuses
      resolve_relation_next_statuses(context[:user]&.id, object)
    end

    def action_a_date
      object.extract_id_date[:action_a_date]
    end

    def action_b_date
      object.extract_id_date[:action_b_date]
    end

    def action_c_date
      object.extract_id_date[:action_c_date]
    end
  end
end
