module Mutations
  class UpdateUserMutation < Mutations::BaseOwnerMutation
    argument :user_id, Int
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :age, Int, required: false
    argument :gender, Types::GenderCategory, required: false

    field :user, Types::UserType

    def resolve(**params)
      user = User.find(params[:user_id])
      user.first_name = params[:first_name] if params.key?(:first_name)
      user.last_name = params[:last_name] if params.key?(:last_name)
      user.age = params[:age] if params.key?(:age)
      user.gender = params[:gender] if params.key?(:gender)
      user.save!
      { user: user }
    end
  end
end