module Mutations
  class UpdateRelationMutation < Mutations::BaseAuthMutation
    include RelationService

    argument :user_id, Int
    argument :status, Types::RelationCategory, required: false

    field :relation, Types::RelationType

    def resolve(**params)
      user_id = context[:user]&.id
      counter_user_id = params[:user_id]
      status = params[:status]
      { relation: update_relation(user_id, counter_user_id, status) }
    end
  end
end
