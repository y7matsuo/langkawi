module Mutations
  class CreateRelationMutation < Mutations::BaseAuthMutation
    include RelationService

    argument :user_id, Int

    field :relation, Types::RelationType

    def resolve(**params)
      user_id = context[:user]&.id
      counter_user_id = params[:user_id]
      { relation: create_relation(user_id, counter_user_id) }
    end
  end
end
