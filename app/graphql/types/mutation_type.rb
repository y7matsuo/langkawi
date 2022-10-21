module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::LoginMutation
    field :logout, mutation: Mutations::LogoutMutation
    field :update_user, mutation: Mutations::UpdateUserMutation
    field :update_user_detail, mutation: Mutations::UpdateUserDetailMutation
    field :create_relation, mutation: Mutations::CreateRelationMutation
    field :update_relation, mutation: Mutations::UpdateRelationMutation
    field :create_talk, mutation: Mutations::CreateTalkMutation
    field :update_talk, mutation: Mutations::UpdateTalkMutation
  end
end
