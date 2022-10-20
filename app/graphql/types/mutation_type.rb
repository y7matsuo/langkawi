module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::LoginMutation
    field :logout, mutation: Mutations::LogoutMutation
    field :update_user, mutation: Mutations::UpdateUserMutation
    field :update_user_detail, mutation: Mutations::UpdateUserDetailMutation
  end
end
