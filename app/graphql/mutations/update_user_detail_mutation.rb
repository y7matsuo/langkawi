module Mutations
  class UpdateUserDetailMutation < Mutations::BaseOwnerMutation
    argument :user_id, Int
    argument :description, String, required: false

    field :user, Types::UserType

    def resolve(**params)
      user_id = params[:user_id]
      user_detail = UserDetail.find_by(user_id: user_id)
      user_detail.description_a = params[:description] if params.key?(:description)
      user_detail.save!
      { user: User.find(user_id) }
    end    
  end
end